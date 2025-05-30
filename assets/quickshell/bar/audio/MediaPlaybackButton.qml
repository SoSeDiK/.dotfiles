import QtQuick
import QtQuick.Controls

import "../.."

Button {
    property real scaleMultiplier: 0.9
    property bool hovering: false
    property string buttonColor: hovering ? (controlButton.down ? ShellGlobals.colors.controlsButtonPressed : ShellGlobals.colors.controlsButtonHovered) : ShellGlobals.colors.controlsButton

    id: controlButton
    implicitHeight: parent.height - ShellGlobals.props.universalPadding
    padding: 0
    topInset: 0
    bottomInset: 0
    rightInset: 0
    leftInset: 0

    contentItem: Text {
        text: controlButton.text
        font.family: ShellGlobals.fonts.iconFontFamily
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: (controlButton.height * 0.9) * scaleMultiplier
        color: buttonColor
    }

    background: Rectangle {
        implicitHeight: controlButton.height
        implicitWidth: implicitHeight
        color: "transparent"
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            hovering = true 
        }

        onExited: {
            hovering = false
        }

        onPressed: {
            controlButton.down = true;
        }

        onReleased: {
            controlButton.down = false;
        }

        onClicked: {
            controlButton.clicked()
        }
    }
}
