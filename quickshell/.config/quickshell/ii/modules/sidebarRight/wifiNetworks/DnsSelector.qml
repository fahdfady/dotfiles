import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

// DNS provider switching (Omarchy parity). DHCP clears the NetworkManager
// drop-in and per-connection overrides; Custom opens a terminal prompt.
// Applying runs through sudo/pkexec, so the row shows a busy note while
// the privileged half runs.
ColumnLayout {
    Layout.fillWidth: true
    spacing: 8

    StyledText {
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.6
        text: Translation.tr("DNS provider")
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6
        enabled: !Network.dnsBusy

        Repeater {
            model: ["DHCP", "Cloudflare", "Google", "Custom"]
            delegate: GroupButton {
                required property string modelData
                Layout.fillWidth: true
                toggled: Network.dnsProvider === modelData
                buttonText: Translation.tr(modelData)
                onClicked: Network.setDnsProvider(modelData)
            }
        }
    }

    StyledText {
        visible: Network.dnsBusy
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.7
        text: Translation.tr("Applying DNS settings…")
    }
}
