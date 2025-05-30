import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../blocks"
import "../.."

Item {
    property string icon: ""
    property string action: ""
    required property var command

    property bool hovering: false
    property bool down: false
    property string buttonColor: hovering ? (down ? ShellGlobals.colors.controlsButtonPressed : ShellGlobals.colors.controlsButtonHovered) : ShellGlobals.colors.commonTextColor

    id: poweMenuAction
    Layout.fillWidth: true
    implicitHeight: lay.height

    RowLayout {
        id: lay
        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.margins: 10
        spacing: 10

        FancyIconText {
            text: poweMenuAction.icon
            color: poweMenuAction.buttonColor
            font.pixelSize: 18
        }
        
        FancyText {
            text: poweMenuAction.action
            color: poweMenuAction.buttonColor
            font.pixelSize: 18
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            poweMenuAction.hovering = true 
        }

        onExited: {
            poweMenuAction.hovering = false
        }

        onPressed: {
            poweMenuAction.down = true;
        }

        onReleased: {
            poweMenuAction.down = false;
        }

        onClicked: {
            monitorRoot.toggleWidget("power")
            commandRunner.running = true
        }
    }

    Process {
        id: commandRunner
        command: poweMenuAction.command
        running: false
    }
}
