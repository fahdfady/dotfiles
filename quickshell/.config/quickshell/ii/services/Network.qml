pragma Singleton
pragma ComponentBehavior: Bound

// Took many bits from https://github.com/caelestia-dots/shell (GPLv3)

import Quickshell
import Quickshell.Io
import QtQuick
import qs.modules.common
import "./network"
import "network/omarchy/NetworkModel.js" as NetModel

/**
 * Network service with nmcli.
 */
Singleton {
    id: root

    property bool wifi: true
    property bool ethernet: false

    property bool wifiEnabled: false
    property bool wifiScanning: false
    property bool wifiConnecting: connectProc.running
    property WifiAccessPoint wifiConnectTarget
    readonly property list<WifiAccessPoint> wifiNetworks: []
    readonly property WifiAccessPoint active: wifiNetworks.find(n => n.active) ?? null
    property string wifiStatus: "disconnected"

    // Saved NetworkManager profile names. Refreshed with the network list so
    // sort order and forget affordances stay correct.
    property var knownSsids: []
    function isKnownSsid(ssid) {
        return knownSsids.indexOf(ssid) !== -1;
    }
    function isEnterpriseSecurity(security) {
        const s = security || "";
        return s.indexOf("802.1X") !== -1 || s.indexOf("EAP") !== -1;
    }
    function isOpenSecurity(security) {
        return !security || security === "--";
    }
    // Omarchy parity: connected first, then known, then strongest signal.
    readonly property var sortedWifiNetworks: [...wifiNetworks].sort((a, b) => {
        if (!!a.active !== !!b.active)
            return a.active ? -1 : 1;
        const ka = isKnownSsid(a.ssid), kb = isKnownSsid(b.ssid);
        if (ka !== kb)
            return ka ? -1 : 1;
        return b.strength - a.strength;
    })

    property string networkName: ""
    property int networkStrength
    property string materialSymbol: root.ethernet
        ? "lan"
        : root.wifiEnabled
            ? (
                Network.networkStrength > 83 ? "signal_wifi_4_bar" :
                Network.networkStrength > 67 ? "network_wifi" :
                Network.networkStrength > 50 ? "network_wifi_3_bar" :
                Network.networkStrength > 33 ? "network_wifi_2_bar" :
                Network.networkStrength > 17 ? "network_wifi_1_bar" :
                "signal_wifi_0_bar"
            )
            : (root.wifiStatus === "connecting")
                ? "signal_wifi_statusbar_not_connected"
                : (root.wifiStatus === "disconnected")
                    ? "wifi_find"
                    : (root.wifiStatus === "disabled")
                        ? "signal_wifi_off"
                        : "signal_wifi_bad"

    // Control
    function enableWifi(enabled = true): void {
        const cmd = enabled ? "on" : "off";
        enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function toggleWifi(): void {
        enableWifi(!wifiEnabled);
    }

    function rescanWifi(): void {
        wifiScanning = true;
        rescanProcess.running = true;
    }

    function connectToWifiNetwork(accessPoint: WifiAccessPoint, password = "", identity = ""): void {
        password = password || "";
        identity = identity || "";
        accessPoint.askingPassword = false;
        root.wifiConnectTarget = accessPoint;
        root._connectStderr = "";
        // We use `dev wifi connect` instead of `connection up SSID` because
        // this also creates a connection profile. Argv passing keeps SSIDs
        // with spaces intact.
        if (identity.length > 0) {
            root._startWifiAction("enterprise", accessPoint.ssid);
            enterpriseConnect.secret = password;
            enterpriseConnect.exec(["bash", "-c", NetModel.enterpriseConnectScript, "nmcli-eap", accessPoint.ssid, identity]);
        } else if (password.length > 0) {
            root._startWifiAction("connect", accessPoint.ssid);
            connectProc.exec(["nmcli", "dev", "wifi", "connect", accessPoint.ssid, "password", password]);
        } else {
            root._startWifiAction("connect", accessPoint.ssid);
            connectProc.exec(["nmcli", "dev", "wifi", "connect", accessPoint.ssid]);
        }
    }

    function disconnectWifiNetwork(): void {
        if (active) {
            root._startWifiAction("disconnect", active.ssid);
            disconnectProc.exec(["nmcli", "connection", "down", active.ssid]);
        }
    }

    function forgetWifiNetwork(ssid): void {
        if (!ssid || forgetProc.running)
            return;
        root._startWifiAction("forget", ssid);
        forgetProc.exec(["nmcli", "connection", "delete", ssid]);
    }

    function refreshWifiLists() {
        getNetworks.running = true;
        knownSsidsProc.running = true;
    }

    // ---- In-flight wifi action state (Omarchy parity) ----
    // wifiActionSsid flips on for the row whose action is running so it can
    // render "Connecting…" / "Disconnecting…" / "Forgetting…".
    // wifiActionTimeout is the backstop: if onExited never fires, the row
    // must not get stuck busy forever.
    property string wifiActionSsid: ""
    property string wifiActionKind: "" // connect | disconnect | forget | enterprise
    property string wifiFailureSsid: ""
    property string wifiFailureReason: ""
    property string _connectStderr: ""
    property string _enterpriseStderr: ""

    function _startWifiAction(kind, ssid) {
        wifiActionSsid = ssid || "";
        wifiActionKind = kind;
        wifiFailureSsid = "";
        wifiFailureReason = "";
        wifiActionTimeout.restart();
    }

    function _clearWifiAction() {
        wifiActionTimeout.stop();
        wifiActionSsid = "";
        wifiActionKind = "";
    }

    function _failWifiAction(ssid, reason) {
        wifiActionTimeout.stop();
        wifiFailureSsid = ssid || "";
        wifiFailureReason = reason || "Connection failed";
        wifiActionSsid = "";
        wifiActionKind = "";
        refreshWifiLists();
    }

    function openPublicWifiPortal() {
        Quickshell.execDetached(["xdg-open", "https://nmcheck.gnome.org/"]) // From some StackExchange thread, seems to work
    }

    function openNetworkSettings(): void {
        const configuredEthernet = (Config.options.apps.networkEthernet || "").trim();
        const configuredNetwork = (Config.options.apps.network || "").trim();
        Quickshell.execDetached({
            environment: ({
                QS_NETWORK_ETHERNET_CMD: configuredEthernet,
                QS_NETWORK_CMD: configuredNetwork
            }),
            command: ["bash", "-c", `
has_kcm_networkmanagement() {
    [ -f /usr/lib/qt6/plugins/plasma/kcms/kcm_networkmanagement.so ] || [ -f /usr/lib/qt/plugins/plasma/kcms/kcm_networkmanagement.so ]
}

run_cmd_if_valid() {
    local cmd="$1"
    [ -n "$cmd" ] || return 1
    if [[ "$cmd" == *kcm_networkmanagement* ]]; then
        command -v kcmshell6 >/dev/null 2>&1 || return 1
        has_kcm_networkmanagement || return 1
    fi
    bash -lc "$cmd"
}

run_cmd_if_valid "$QS_NETWORK_ETHERNET_CMD" && exit 0
command -v nm-connection-editor >/dev/null 2>&1 && exec nm-connection-editor
run_cmd_if_valid "$QS_NETWORK_CMD" && exit 0
command -v kcmshell6 >/dev/null 2>&1 && has_kcm_networkmanagement && exec kcmshell6 kcm_networkmanagement
command -v nmtui >/dev/null 2>&1 && command -v kitty >/dev/null 2>&1 && exec kitty -1 sh -lc nmtui
`]
        })
    }

    // Compat wrapper: the old modify-in-place flow never re-applied the
    // profile correctly. Reconnecting with the password covers both the
    // first connect and the wrong-saved-password retry.
    function changePassword(network: WifiAccessPoint, password: string, username = ""): void {
        connectToWifiNetwork(network, password, username);
    }

    Process {
        id: enableWifiProc
    }

    Process {
        id: connectProc
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: SplitParser {
            onRead: line => {
                getNetworks.running = true
            }
        }
        stderr: SplitParser {
            onRead: line => {
                root._connectStderr += line + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const target = root.wifiConnectTarget;
            const err = root._connectStderr;
            const needsSecrets = err.includes("Secrets were required")
                || err.includes("802-11-wireless-security")
                || err.includes("no secrets");
            if (exitCode === 0) {
                if (target)
                    target.askingPassword = false;
                root._clearWifiAction();
            } else if (root.wifiActionKind === "connect" && needsSecrets) {
                // Wrong or missing passphrase: reprompt inline instead of
                // dropping back to the list with no explanation.
                if (target)
                    target.askingPassword = true;
                wifiActionTimeout.stop();
                root.wifiFailureSsid = target ? target.ssid : "";
                root.wifiFailureReason = "Wrong password";
                root.wifiActionSsid = "";
                root.wifiActionKind = "";
            } else {
                root._failWifiAction(target ? target.ssid : "", "Connection failed");
            }
            root.wifiConnectTarget = null;
            root.refreshWifiLists();
        }
    }

    Process {
        id: disconnectProc
        stdout: SplitParser {
            onRead: getNetworks.running = true
        }
        onExited: (exitCode, exitStatus) => {
            if (root.wifiActionKind === "disconnect")
                root._clearWifiAction();
            root.refreshWifiLists();
        }
    }

    Process {
        id: forgetProc
        stdout: SplitParser {}
        stderr: SplitParser {}
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                if (root.wifiActionKind === "forget")
                    root._clearWifiAction();
            } else {
                root._failWifiAction(root.wifiActionSsid, "Could not forget network");
            }
            root.refreshWifiLists();
        }
    }

    // Creates and activates the 802.1X profile (see
    // NetModel.enterpriseConnectScript). The password travels over stdin,
    // never argv (argv is world-readable in /proc).
    Process {
        id: enterpriseConnect
        property string secret: ""
        stdinEnabled: true
        onStarted: {
            write(secret + "\n");
            secret = "";
        }
        stdout: SplitParser {}
        stderr: SplitParser {
            onRead: line => {
                root._enterpriseStderr += line + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const target = root.wifiConnectTarget;
            if (exitCode === 0) {
                if (target)
                    target.askingPassword = false;
                root._clearWifiAction();
            } else {
                if (target)
                    target.askingPassword = true;
                root._failWifiAction(target ? target.ssid : "", "Connection failed");
            }
            root.wifiConnectTarget = null;
            root.refreshWifiLists();
        }
    }

    Timer {
        id: wifiActionTimeout
        // Must outlast NetworkManager's ~25s supplicant timeout: a wrong
        // saved PSK fails late, and that failure has to land while the
        // action is still tracked to show "Wrong password".
        interval: 30000
        repeat: false
        onTriggered: {
            if (!root.wifiActionKind)
                return;
            root.wifiFailureSsid = root.wifiActionSsid;
            root.wifiFailureReason = "Timed out";
            root.wifiActionSsid = "";
            root.wifiActionKind = "";
            root.refreshWifiLists();
        }
    }

    Process {
        id: rescanProcess
        command: ["nmcli", "dev", "wifi", "list", "--rescan", "yes"]
        stdout: SplitParser {
            onRead: {
                wifiScanning = false;
                getNetworks.running = true;
            }
        }
    }

    // Status update
    function update() {
        updateConnectionType.startCheck();
        knownSsidsProc.running = true;
        wifiStatusProcess.running = true
        updateNetworkName.running = true;
        updateNetworkStrength.running = true;
    }

    Process {
        id: subscriber
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: root.update()
        }
    }

    Process {
        id: updateConnectionType
        property string buffer
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE d status && nmcli -t -f CONNECTIVITY g"]
        running: true
        function startCheck() {
            buffer = "";
            updateConnectionType.running = true;
        }
        stdout: SplitParser {
            onRead: data => {
                updateConnectionType.buffer += data + "\n";
            }
        }
        onExited: (exitCode, exitStatus) => {
            const lines = updateConnectionType.buffer.trim().split('\n');
            const connectivity = lines.pop() // none, limited, full
            let hasEthernet = false;
            let hasWifi = false;
            let wifiStatus = "disconnected";
            lines.forEach(line => {
                if (line.includes("ethernet") && line.includes("connected"))
                    hasEthernet = true;
                else if (line.includes("wifi:")) {
                    if (line.includes("disconnected")) {
                        wifiStatus = "disconnected"
                    }
                    else if (line.includes("connected")) {
                        hasWifi = true;
                        wifiStatus = "connected"

                        if (connectivity === "limited") {
                            hasWifi = false;
                            wifiStatus = "limited"
                        }
                    }
                    else if (line.includes("connecting")) {
                        wifiStatus = "connecting"
                    }
                    else if (line.includes("unavailable")) {
                        wifiStatus = "disabled"
                    }
                }
            });
            root.wifiStatus = wifiStatus;
            root.ethernet = hasEthernet;
            root.wifi = hasWifi;
            root.wifiDevicePresent = lines.some(line => line.includes("wifi:"));
        }
    }

    Process {
        id: updateNetworkName
        command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                root.networkName = data;
            }
        }
    }

    Process {
        id: updateNetworkStrength
        running: true
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\*/{if (NR!=1) {print $2}}'"]
        stdout: SplitParser {
            onRead: data => {
                root.networkStrength = parseInt(data);
            }
        }
    }

    Process {
        id: wifiStatusProcess
        command: ["nmcli", "radio", "wifi"]
        Component.onCompleted: running = true
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled";
            }
        }
    }

    Process {
        id: knownSsidsProc
        running: true
        command: ["nmcli", "-g", "NAME", "connection", "show"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                root.knownSsids = text.trim().split("\n").filter(n => n.length > 0);
            }
        }
    }

    Process {
        id: getNetworks
        running: true
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY", "d", "w"]
        environment: ({
            LANG: "C",
            LC_ALL: "C"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED";
                const rep = new RegExp("\\\\:", "g");
                const rep2 = new RegExp(PLACEHOLDER, "g");

                const allNetworks = text.trim().split("\n").map(n => {
                    const net = n.replace(rep, PLACEHOLDER).split(":");
                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2]),
                        ssid: net[3],
                        bssid: net[4]?.replace(rep2, ":") ?? "",
                        security: net[5] || ""
                    };
                }).filter(n => n.ssid && n.ssid.length > 0);

                // Group networks by SSID and prioritize connected ones
                const networkMap = new Map();
                for (const network of allNetworks) {
                    const existing = networkMap.get(network.ssid);
                    if (!existing) {
                        networkMap.set(network.ssid, network);
                    } else {
                        // Prioritize active/connected networks
                        if (network.active && !existing.active) {
                            networkMap.set(network.ssid, network);
                        } else if (!network.active && !existing.active) {
                            // If both are inactive, keep the one with better signal
                            if (network.strength > existing.strength) {
                                networkMap.set(network.ssid, network);
                            }
                        }
                        // If existing is active and new is not, keep existing
                    }
                }

                const wifiNetworks = Array.from(networkMap.values());

                const rNetworks = root.wifiNetworks;

                const destroyed = rNetworks.filter(rn => !wifiNetworks.find(n => n.frequency === rn.frequency && n.ssid === rn.ssid && n.bssid === rn.bssid));
                for (const network of destroyed)
                    rNetworks.splice(rNetworks.indexOf(network), 1).forEach(n => n.destroy());

                for (const network of wifiNetworks) {
                    const match = rNetworks.find(n => n.frequency === network.frequency && n.ssid === network.ssid && n.bssid === network.bssid);
                    if (match) {
                        match.lastIpcObject = network;
                    } else {
                        rNetworks.push(apComp.createObject(root, {
                            lastIpcObject: network
                        }));
                    }
                }
            }
        }
    }

    // ===== Omarchy wifi port: link details / stats / band / DNS =====
    // UI sets detailsActive while the wifi dialog is open. Every poller
    // below only runs then, so an idle bar costs nothing extra.
    property bool detailsActive: false

    readonly property string omarchyBin: Quickshell.shellPath("services/network/omarchy/bin")

    // Parsed `qs-network-status --verbose` rows: iface, ip, prefix, gateway,
    // type (wifi/ethernet), ssid, signal_dbm, freq, bitrate, speed, duplex,
    // rx_bytes, tx_bytes, router_ping_ms, internet_ping_ms.
    property var linkInfo: ({})
    property real downloadRate: 0
    property real uploadRate: 0
    property real routerPingLatency: -1
    property real internetPingLatency: -1
    property int internetPingPacketLoss: 0
    property var _tpState: ({})
    property var _pingState: ({})

    property string dnsProvider: ""
    property string _pendingDnsProvider: ""
    property string bandCurrent: ""
    property string bandSelected: "auto"
    property var bandAvailable: []
    property string _pendingBand: ""
    readonly property bool bandBusy: _pendingBand !== ""
    readonly property string bandEffective: _pendingBand !== "" ? _pendingBand : bandSelected
    readonly property bool bandPinned: bandEffective !== "auto"
    // Wi-Fi only: on ethernet the band of a secondary radio is not what the
    // dialog describes. bandBusy keeps the section mounted across the
    // reconnect a band change causes.
    readonly property bool canSelectBand: ((linkInfo.type || "") === "wifi" || bandBusy)
        && (bandAvailable.length > 1 || bandPinned)
    readonly property string bandSectionTitle: NetModel.bandSectionTitle(bandEffective, bandCurrent)
    readonly property bool hasTransferStats: linkInfo.rx_bytes !== undefined
    readonly property bool hasPingSamples: !!(_pingState.internetPingSamples && _pingState.internetPingSamples.length > 0)
    // The hero switch is the Wi-Fi radio, so it only exists when there is a
    // radio to switch. On a wired box it would otherwise sit there reading
    // "off" beside a perfectly live ethernet connection.
    property bool wifiDevicePresent: true
    readonly property bool canToggleWifi: wifiDevicePresent

    function headerDetail() {
        return NetModel.headerDetail({ type: linkInfo.type || "", speed: linkInfo.speed || "" });
    }

    function formatRate(bytesPerSec) {
        return NetModel.formatRate(bytesPerSec);
    }

    function formatBytes(bytes) {
        return NetModel.formatBytes(bytes);
    }

    function pingText() {
        return NetModel.formatPingLatency(internetPingLatency, hasPingSamples);
    }

    function packetLossText() {
        return NetModel.formatPacketLoss(internetPingPacketLoss, hasPingSamples);
    }

    function refreshDetails() {
        if (!detailsProc.running)
            detailsProc.running = true;
    }

    function _ingestVerbose(text) {
        const info = NetModel.parseKeyValue(text);
        const now = Date.now() / 1000;
        const tp = NetModel.throughputState(_tpState, info, now);
        _tpState = tp;
        downloadRate = tp.downloadRate;
        uploadRate = tp.uploadRate;
        const ps = NetModel.pingLatencyState(_pingState, info, 24, 5);
        _pingState = ps;
        routerPingLatency = ps.routerPingLatency;
        internetPingLatency = ps.internetPingLatency;
        internetPingPacketLoss = ps.internetPingPacketLoss;
        linkInfo = info;
    }

    function _ingestBand(text) {
        const status = NetModel.parseBandStatus(text);
        // Mid-reconnect there is no connected station, so the command reports
        // nothing. Publishing that would empty the option list on every toggle.
        if (bandBusy && status.available.length === 0)
            return;
        bandCurrent = status.band;
        bandSelected = status.selected;
        bandAvailable = status.available;
    }

    function setBand(band) {
        if (!band || bandSetProc.running)
            return;
        _pendingBand = band;
        bandSetProc.exec([omarchyBin + "/qs-network-band", band]);
    }

    function setDnsProvider(provider) {
        if (!provider || dnsSetProc.running)
            return;
        if (provider === "Custom") {
            runCustomDnsInTerminal();
            return;
        }
        _pendingDnsProvider = provider;
        dnsSetProc.exec([omarchyBin + "/qs-dns", provider]);
    }

    property string customDnsTerminal: "kitty"

    function runCustomDnsInTerminal() {
        Quickshell.execDetached([customDnsTerminal, "-1", "sh", "-lc", omarchyBin + "/qs-dns Custom"]);
    }

    onDetailsActiveChanged: {
        if (detailsActive) {
            refreshDetails();
            if (!bandProc.running)
                bandProc.running = true;
            if (!dnsProc.running)
                dnsProc.running = true;
        }
    }

    Process {
        id: detailsProc
        command: [root.omarchyBin + "/qs-network-status", "--verbose"]
        stdout: StdioCollector {
            onStreamFinished: root._ingestVerbose(text)
        }
    }

    Timer {
        id: detailsPoll
        interval: 1500
        repeat: true
        triggeredOnStart: true
        running: root.detailsActive
        onTriggered: root.refreshDetails()
    }

    Process {
        id: bandProc
        command: [root.omarchyBin + "/qs-network-band"]
        stdout: StdioCollector {
            onStreamFinished: root._ingestBand(text)
        }
    }

    // Slower than detailsPoll on purpose: this shells out to nmcli several
    // times, and band availability only moves when a scan turns up a BSSID.
    Timer {
        id: bandPoll
        interval: 4000
        repeat: true
        running: root.detailsActive
        onTriggered: {
            if (!bandProc.running)
                bandProc.running = true;
        }
    }

    Process {
        id: dnsProc
        command: [root.omarchyBin + "/qs-dns"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.dnsProvider = text.trim() || "DHCP";
            }
        }
    }

    // Action runner for DNS provider changes. Wi-Fi actions use
    // NetworkManager's nmcli backend directly (see Slice 3).
    Process {
        id: dnsSetProc
        stdout: SplitParser {}
        stderr: SplitParser {}
        onExited: (exitCode, exitStatus) => {
            if (root._pendingDnsProvider !== "") {
                if (exitCode === 0)
                    root.dnsProvider = root._pendingDnsProvider;
                root._pendingDnsProvider = "";
            }
        }
    }

    // Band changes reassociate; refresh state after the reconnect instead of
    // leaving stale readings until the next poll tick.
    Process {
        id: bandSetProc
        stdout: SplitParser {}
        stderr: SplitParser {}
        onExited: (exitCode, exitStatus) => {
            if (root._pendingBand !== "") {
                if (exitCode === 0)
                    root.bandSelected = root._pendingBand;
                root._pendingBand = "";
                root.refreshDetails();
                if (!bandProc.running)
                    bandProc.running = true;
            }
        }
    }

    Component {
        id: apComp

        WifiAccessPoint {}
    }
}
