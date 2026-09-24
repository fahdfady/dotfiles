import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import "../"
import qs
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QuickToggleButton {
    // When true this button opens the Wi-Fi configuration instead of toggling
    // the radio: enabling/disabling a connection lives inside the dialog.
    property bool openConfiguration: false

    toggled: Network.wifiStatus !== "disabled"
    buttonIcon: Network.materialSymbol
    onClicked: {
        if (openConfiguration) {
            GlobalStates.sidebarRightOpen = true;
            GlobalStates.wifiDialogRequest++;
        } else {
            Network.toggleWifi();
        }
    }
    altAction: openConfiguration ? null : () => {
        Network.openNetworkSettings()
        GlobalStates.sidebarRightOpen = false
    }
    StyledToolTip {
        text: openConfiguration
            ? Translation.tr("Wi-Fi | Click to configure")
            : Translation.tr("%1 | Right-click to configure").arg(Network.networkName)
    }
}
