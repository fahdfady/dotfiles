import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

// DNS provider switching (Omarchy parity). DHCP clears the NetworkManager
// drop-in and per-connection overrides; Custom opens a terminal prompt.
// Applying runs through sudo/pkexec, so the row shows a busy note while
// the privileged half runs. Providers share the row width equally.
ColumnLayout {
    Layout.fillWidth: true
    spacing: 8

    StyledText {
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.6
        text: Translation.tr("DNS provider")
    }

    Row {
        Layout.fillWidth: true
        spacing: 6
        enabled: !Network.dnsBusy

        readonly property int count: 4
        readonly property real cellWidth: (width - spacing * (count - 1)) / count

        Repeater {
            model: ["DHCP", "Cloudflare", "Google", "Custom"]
            delegate: SelectionGroupButton {
                id: dnsPill
                required property string modelData
                required property int index
                width: parent.cellWidth
                horizontalPadding: 4
                leftmost: true
                rightmost: true
                toggled: Network.dnsProvider === modelData
                buttonText: Translation.tr(modelData)
                onClicked: Network.setDnsProvider(modelData)

                contentItem: StyledText {
                    text: dnsPill.buttonText
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    color: dnsPill.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                }
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
