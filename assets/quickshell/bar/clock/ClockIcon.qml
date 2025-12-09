import QtQuick

import "../.."

Text {
    property int hour: 0

    text: getTimeIcon(hour)
    color: ShellGlobals.colors.widget
    font.family: ShellGlobals.fonts.iconFontFamily
    font.weight: Font.Bold
    font.pixelSize: parent.height * 0.85
    y: -(height - font.pixelSize) / 4

    readonly property var timeIcons: {
        12: "󱑖",
        11: "󱑕",
        10: "󱑔",
        9: "󱑓",
        8: "󱑒",
        7: "󱑑",
        6: "󱑐",
        5: "󱑏",
        4: "󱑎",
        3: "󱑍",
        2: "󱑌",
        1: "󱑋",
    }

    function getTimeIcon(hour) {
        if (hour > 12) hour -= 12;
        else if (hour === 0) hour = 12;
        return timeIcons[hour];
    }
}
