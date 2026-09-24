import qs
import qs.services
import qs.services.network
import qs.modules.common
import qs.modules.common.widgets
import "../quickToggles/"
import QtQuick
import QtQuick.Layouts
import Quickshell

WindowDialog {
    id: root

    // The dialog carries hero + stats + band + DNS above a scrolling list, so
    // it needs more room than the shared 600 default.
    backgroundHeight: 820

    WindowDialogTitle {
        text: Translation.tr("Wi-Fi")
    }

    // Hero: status icon · name + state · radio switch
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        MaterialSymbol {
            Layout.alignment: Qt.AlignVCenter
            text: Network.materialSymbol
            iconSize: Appearance.font.pixelSize.larger * 1.8
            color: Appearance.colors.colOnSurfaceVariant
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                color: Appearance.colors.colOnSurfaceVariant
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.larger
                font.bold: true
                text: {
                    const kind = Network.linkInfo.type || "";
                    let name = Translation.tr("Disconnected");
                    if (kind === "ethernet" || (kind === "" && Network.ethernet))
                        name = "Ethernet";
                    else if (kind === "wifi")
                        name = Network.linkInfo.ssid || Network.networkName || "Wi-Fi";
                    else if (Network.networkName.length > 0)
                        name = Network.networkName;
                    const detail = Network.headerDetail();
                    return detail !== "" ? name + " (" + detail + ")" : name;
                }
            }

            StyledText {
                Layout.fillWidth: true
                color: Appearance.colors.colOnSurfaceVariant
                elide: Text.ElideRight
                opacity: 0.7
                text: {
                    if (Network.ethernet || (Network.linkInfo.type || "") === "ethernet")
                        return Translation.tr("Connected");
                    if (!Network.wifiEnabled)
                        return Translation.tr("Wi-Fi off");
                    if (Network.wifiStatus === "connecting" || Network.wifiConnecting)
                        return Translation.tr("Connecting…");
                    if (Network.active)
                        return Translation.tr("Connected");
                    return Translation.tr("Not connected");
                }
            }
        }

        NetworkToggle {
            visible: Network.canToggleWifi
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // Connection details: every stat row stays mounted and reads "--" until
    // its first sample lands, so late data never reflows the dialog.
    GridLayout {
        Layout.fillWidth: true
        columns: 4
        columnSpacing: 12
        rowSpacing: 2

        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Ping")
        }
        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            color: (Network.hasPingSamples && Network.internetPingPacketLoss > 0) ? Appearance.colors.colError : Appearance.colors.colOnSurfaceVariant
            text: Network.pingText()
        }
        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Packet loss")
        }
        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            horizontalAlignment: Text.AlignRight
            color: (Network.hasPingSamples && Network.internetPingPacketLoss > 0) ? Appearance.colors.colError : Appearance.colors.colOnSurfaceVariant
            text: Network.packetLossText()
        }

        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Receiving")
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            color: Appearance.colors.colOnSurfaceVariant
            text: Network.hasTransferStats ? Network.formatRate(Network.downloadRate) : "--"
        }
        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Sending")
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            color: Appearance.colors.colOnSurfaceVariant
            text: Network.hasTransferStats ? Network.formatRate(Network.uploadRate) : "--"
        }

        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Downloaded")
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            color: Appearance.colors.colOnSurfaceVariant
            text: Network.hasTransferStats ? Network.formatBytes(parseFloat(Network.linkInfo.rx_bytes || "0")) : "--"
        }
        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Uploaded")
        }
        StyledText {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            color: Appearance.colors.colOnSurfaceVariant
            text: Network.hasTransferStats ? Network.formatBytes(parseFloat(Network.linkInfo.tx_bytes || "0")) : "--"
        }

        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("IP address")
        }
        // Selectable (not just clickable) so the address can be copied
        // without depending on wl-copy being installed.
        TextEdit {
            Layout.fillWidth: true
            readOnly: true
            selectByMouse: true
            color: Appearance.colors.colOnSurfaceVariant
            horizontalAlignment: Text.AlignRight
            text: Network.linkInfo.ip || "--"
        }
        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Gateway")
        }
        TextEdit {
            Layout.fillWidth: true
            readOnly: true
            selectByMouse: true
            color: Appearance.colors.colOnSurfaceVariant
            horizontalAlignment: Text.AlignRight
            text: Network.linkInfo.gateway || "--"
        }
    }

    WifiBandSelector {}

    DnsSelector {}

    WindowDialogSeparator {
        visible: !Network.wifiScanning
    }
    StyledIndeterminateProgressBar {
        visible: Network.wifiScanning
        Layout.fillWidth: true
        Layout.topMargin: -8
        Layout.bottomMargin: -8
        Layout.leftMargin: -Appearance.rounding.large
        Layout.rightMargin: -Appearance.rounding.large
    }
    ListView {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.topMargin: -15
        Layout.bottomMargin: -16
        Layout.leftMargin: -Appearance.rounding.large
        Layout.rightMargin: -Appearance.rounding.large

        clip: true
        spacing: 0

        model: ScriptModel {
            // Omarchy order: connected first, then known, then strongest.
            values: Network.sortedWifiNetworks
        }
        delegate: WifiNetworkItem {
            required property WifiAccessPoint modelData
            wifiNetwork: modelData
            anchors {
                left: parent?.left
                right: parent?.right
            }
        }
    }
    WindowDialogSeparator {}
    WindowDialogButtonRow {
        DialogButton {
            buttonText: Translation.tr("Details")
            onClicked: {
                Network.openNetworkSettings();
                GlobalStates.sidebarRightOpen = false;
            }
        }

        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            buttonText: Translation.tr("Done")
            onClicked: root.dismiss()
        }
    }
}
