import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

// Wi-Fi band pinning (Omarchy parity). Only visible when there is a real
// choice, or when a pin is in force on a single-band scan -- otherwise the
// Automatic switch would vanish and the pin become unclearable.
ColumnLayout {
    visible: Network.canSelectBand
    Layout.fillWidth: true
    spacing: 8

    StyledText {
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.6
        text: Network.bandSectionTitle
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6
        enabled: !Network.bandBusy

        GroupButton {
            Layout.fillWidth: true
            toggled: !Network.bandPinned
            buttonText: Translation.tr("Automatic")
            onClicked: Network.setBand("auto")
        }

        Repeater {
            model: Network.bandAvailable
            delegate: GroupButton {
                required property string modelData
                Layout.fillWidth: true
                toggled: Network.bandEffective === modelData
                buttonText: modelData + "GHz"
                onClicked: Network.setBand(modelData)
            }
        }
    }
}
