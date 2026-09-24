import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

// Wi-Fi band pinning (Omarchy parity). Automatic rides on the section header
// as a switch; the band pills only appear once a band is pinned, so under
// Automatic there is nothing to choose between. Pills share the row width
// equally (plain Row + explicit widths) to avoid the GroupButton clickIndex
// layout logic that only makes sense inside a ButtonGroup.
ColumnLayout {
    visible: Network.canSelectBand
    Layout.fillWidth: true
    spacing: 8

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        StyledText {
            Layout.fillWidth: true
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Network.bandSectionTitle
        }

        StyledText {
            color: Appearance.colors.colOnSurfaceVariant
            opacity: 0.6
            text: Translation.tr("Automatic")
        }

        StyledSwitch {
            enabled: !Network.bandBusy
            checked: !Network.bandPinned
            onClicked: {
                if (Network.bandPinned)
                    Network.setBand("auto");
                else if (Network.bandCurrent !== "")
                    Network.setBand(Network.bandCurrent);
            }
        }
    }

    Row {
        Layout.fillWidth: true
        spacing: 6
        visible: Network.bandPinned

        readonly property int count: Math.max(1, Network.bandAvailable.length)
        readonly property real cellWidth: (width - spacing * (count - 1)) / count

        Repeater {
            model: Network.bandAvailable
            delegate: SelectionGroupButton {
                id: bandPill
                required property string modelData
                required property int index
                width: parent.cellWidth
                horizontalPadding: 4
                leftmost: true
                rightmost: true
                toggled: Network.bandEffective === modelData
                buttonText: modelData + "GHz"
                onClicked: Network.setBand(modelData)

                contentItem: StyledText {
                    text: bandPill.buttonText
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    color: bandPill.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                }
            }
        }
    }
}
