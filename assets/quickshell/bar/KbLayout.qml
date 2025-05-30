import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."

Rectangle {
    property string currentLayout: "en"

    id: kbLayout
    height: parent.height
    implicitWidth: layoutName.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    Text {
        id: layoutName
        text: currentLayout
        color: "white"
        font.family: ShellGlobals.fonts.fontFamily
        font.weight: Font.Bold
        font.pixelSize: 0.9 * (parent.height - ShellGlobals.props.universalPadding)
        y: -(height - font.pixelSize) / 4
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        Hyprland.rawEvent.connect(hyprlandEvent);
    }

    function hyprlandEvent(event) {
        if (event.name !== "activelayout") return;

        const data = event.parse(2);
        if (data[0] !== "keyd-virtual-keyboard") return;

        currentLayout = getLayoutName(data[1]);
    }

    function getLayoutName(keymap) {
        if (keymap === "English (US)") return "en";
        if (keymap === "Russian-Ukrainian (United)") return "ua";
        return "lang";
    }
}
