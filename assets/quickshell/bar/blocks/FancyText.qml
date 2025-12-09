import QtQuick
import QtQuick.Layouts

import "../.."

Text {
    property real scaling: 0.9

    font.family: ShellGlobals.fonts.fontFamily
    font.weight: Font.Bold
    font.pixelSize: scaling * parent.height
    y: -(height - font.pixelSize) / 4
}
