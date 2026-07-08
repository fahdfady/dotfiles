import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        Layout.margins: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                StyledText {
                    text: Translation.tr("Prayer times")
                    font.pixelSize: Appearance.font.pixelSize.large
                    color: Appearance.colors.colOnLayer1
                }
                StyledText {
                    text: PrayerTimes.locationLabel
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1Inactive
                }
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                visible: PrayerTimes.nextPrayerName.length > 0
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: Translation.tr("Next: %1 %2").arg(PrayerTimes.nextPrayerName).arg(PrayerTimes.nextPrayerTime)
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSecondary
            }
        }

        ColumnLayout {
            spacing: 6
            Repeater {
                model: PrayerTimes.prayers
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    radius: Appearance.rounding.small
                    border.color: modelData.isNext ? Appearance.colors.colPrimary : Appearance.colors.colOutlineVariant
                    border.width: 1
                    color: modelData.isNext ? ColorUtils.transparentize(Appearance.colors.colPrimary, 0.75) : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 12
                        StyledText {
                            text: modelData.name
                            font.pixelSize: Appearance.font.pixelSize.normal
                            color: modelData.isNext ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                        }
                        Item { Layout.fillWidth: true }
                        StyledText {
                            text: modelData.time
                            font.pixelSize: Appearance.font.pixelSize.normal
                            color: modelData.isNext ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                        }
                    }
                }
            }
        }

        StyledText {
            visible: PrayerTimes.prayers.length === 0
            text: Translation.tr("Provide coordinates or enable weather so prayer times can be calculated.")
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer1Inactive
            wrapMode: Text.WordWrap
        }
    }
}
