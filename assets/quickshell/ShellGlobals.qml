pragma Singleton

import Quickshell

import QtQuick

Singleton {
    readonly property var fonts: QtObject {
        readonly property string fontFamily: "FiraCode Nerd Font Mono"
        readonly property string iconFontFamily: "Symbols Nerd Font"
    }
    readonly property var colors: QtObject {
        readonly property color commonTextColor: "#FFFFFFFF"
        readonly property color workspaceTextColor: "#FFD5ABCB"
        readonly property color workspaceEmptyTextColor: "#FF343C42"
        readonly property color workspaceActiveTextColor: "#FF3498DB"
        readonly property color workspaceActivePressedTextColor:"#FF439C07"
        readonly property color workspaceActiveHovereredTextColor: "#FF44AA00"
        readonly property color workspaceSpecialBackground: "#FFA0A8DF"
        readonly property color workspaceSpecialPressedBackground: "#FFD66E8B"
        readonly property color workspaceSpecialHoveredBackground: "#FFD77E97"
        readonly property color timeTextColor: "#FFD5ABCB"
        readonly property color widget: "#FF232436"
        readonly property color widgetOutline: "#FF353D42"
        readonly property color controlsButton: "#AAFFFFFF"
        readonly property color controlsButtonPressed: "#FF9FBED2"
        readonly property color controlsButtonHovered: "#FFB8DBEE"
        readonly property color mediaProgressBackground: "#FF383750"
        readonly property color mediaProgress: "#FFB2B0E5"
        readonly property color batteryColor: "#FFB5E2EE"
        readonly property color batteryLowColor: "#FFF93E3E"
        readonly property color audioColor: "#FFF096AE"
        readonly property color powerColor: "#FFF096AE"
    }
    readonly property var props: QtObject {
        readonly property int barHeight: 26
        readonly property int barOffset: 0
        readonly property int universalPadding: 10
        readonly property bool focusMode: false
        readonly property int widgetRounding: 8
        readonly property int batteryLowLevel: 20
    }
    readonly property var apps: QtObject {
        readonly property string clockApp: "gnome-clocks"
        readonly property string audioMixerApp: "pavucontrol"
    }
    readonly property var actions: QtObject {
        readonly property var suspend: ["systemctl", "suspend"]
        readonly property var reboot: ["systemctl", "reboot"]
        readonly property var logout: ["hyprctl", "dispatch exit"]
        readonly property var shutdown: ["systemctl", "poweroff"]
    }
}
