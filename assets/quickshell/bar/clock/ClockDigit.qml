import QtQuick
import QtQuick.Layouts

import "../.."

Text {
    color: ShellGlobals.colors.timeTextColor
    font.family: ShellGlobals.fonts.fontFamily
    font.weight: Font.Bold
    font.pixelSize: 0.9 * parent.height
    y: -(height - font.pixelSize) / 4
}
