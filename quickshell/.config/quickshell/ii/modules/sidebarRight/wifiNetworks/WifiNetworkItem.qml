import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs.services.network
import QtQuick
import QtQuick.Layouts

DialogListItem {
    id: root
    required property WifiAccessPoint wifiNetwork
    enabled: !(Network.wifiConnectTarget === root.wifiNetwork && !wifiNetwork?.active)

    active: (wifiNetwork?.askingPassword || wifiNetwork?.active) ?? false
    onClicked: {
        if (!wifiNetwork)
            return;
        // Clicking the connected row disconnects; a stale row must never hit
        // an unrelated network, so rows without a live object do nothing.
        if (wifiNetwork.active) {
            Network.disconnectWifiNetwork();
            return;
        }
        if (!Network.isOpenSecurity(wifiNetwork.security) && !Network.isKnownSsid(wifiNetwork.ssid)) {
            wifiNetwork.askingPassword = true;
            return;
        }
        Network.connectToWifiNetwork(wifiNetwork);
    }

    function submitCredentials() {
        if (!root.wifiNetwork)
            return;
        const enterprise = Network.isEnterpriseSecurity(root.wifiNetwork.security ?? "");
        Network.connectToWifiNetwork(root.wifiNetwork, passwordField.text, enterprise ? identityField.text : "");
    }

    contentItem: ColumnLayout {
        anchors {
            fill: parent
            topMargin: root.verticalPadding
            bottomMargin: root.verticalPadding
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 0

        RowLayout {
            // Name
            spacing: 10
            MaterialSymbol {
                iconSize: Appearance.font.pixelSize.larger
                property int strength: root.wifiNetwork?.strength ?? 0
                text: strength > 80 ? "signal_wifi_4_bar" : strength > 60 ? "network_wifi_3_bar" : strength > 40 ? "network_wifi_2_bar" : strength > 20 ? "network_wifi_1_bar" : "signal_wifi_0_bar"
                color: Appearance.colors.colOnSurfaceVariant
            }
            StyledText {
                Layout.fillWidth: true
                color: Appearance.colors.colOnSurfaceVariant
                elide: Text.ElideRight
                text: root.wifiNetwork?.ssid ?? Translation.tr("Unknown")
            }
            MaterialSymbol {
                visible: (root.wifiNetwork?.isSecure || root.wifiNetwork?.active) ?? false
                text: root.wifiNetwork?.active ? "check" : Network.wifiConnectTarget === root.wifiNetwork ? "settings_ethernet" : "lock"
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.colOnSurfaceVariant
            }
        }

        StyledText { // Action status: Connecting… / Connected / failure
            visible: text.length > 0
            Layout.fillWidth: true
            color: Appearance.colors.colOnSurfaceVariant
            elide: Text.ElideRight
            text: {
                if (!root.wifiNetwork)
                    return "";
                if (Network.wifiFailureSsid === root.wifiNetwork.ssid && Network.wifiFailureReason.length > 0)
                    return Network.wifiFailureReason;
                if (Network.wifiActionSsid === root.wifiNetwork.ssid && Network.wifiActionKind.length > 0) {
                    if (Network.wifiActionKind === "disconnect")
                        return Translation.tr("Disconnecting…");
                    if (Network.wifiActionKind === "forget")
                        return Translation.tr("Forgetting…");
                    return Translation.tr("Connecting…");
                }
                if (root.wifiNetwork.active)
                    return Translation.tr("Connected");
                return "";
            }
        }

        RowLayout { // Forget a saved (but not connected) network
            visible: (root.wifiNetwork && !root.wifiNetwork.active && Network.isKnownSsid(root.wifiNetwork.ssid)) ?? false
            Layout.fillWidth: true

            DialogButton {
                buttonText: Translation.tr("Forget")
                onClicked: {
                    Network.forgetWifiNetwork(root.wifiNetwork.ssid);
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        ColumnLayout { // Password
            id: passwordPrompt
            Layout.topMargin: 8
            visible: root.wifiNetwork?.askingPassword ?? false

            MaterialTextField {
                id: identityField
                visible: Network.isEnterpriseSecurity(root.wifiNetwork?.security ?? "")
                Layout.fillWidth: true
                placeholderText: Translation.tr("Identity (user@domain)")

                onAccepted: {
                    passwordField.forceActiveFocus();
                }
            }

            MaterialTextField {
                id: passwordField
                Layout.fillWidth: true
                placeholderText: Translation.tr("Password")

                // Password
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onAccepted: {
                    root.submitCredentials();
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Item {
                    Layout.fillWidth: true
                }

                DialogButton {
                    buttonText: Translation.tr("Cancel")
                    onClicked: {
                        root.wifiNetwork.askingPassword = false;
                    }
                }

                DialogButton {
                    buttonText: Translation.tr("Connect")
                    onClicked: {
                        root.submitCredentials();
                    }
                }
            }
        }

        ColumnLayout { // Public wifi login page
            id: publicWifiPortal
            Layout.topMargin: 8
            visible: (root.wifiNetwork?.active && (root.wifiNetwork?.security ?? "").trim().length === 0) ?? false

            RowLayout {
                DialogButton {
                    Layout.fillWidth: true
                    buttonText: Translation.tr("Open network portal")
                    colBackground: Appearance.colors.colLayer4
                    colBackgroundHover: Appearance.colors.colLayer4Hover
                    colRipple: Appearance.colors.colLayer4Active
                    onClicked: {
                        Network.openPublicWifiPortal()
                        GlobalStates.sidebarRightOpen = false
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
