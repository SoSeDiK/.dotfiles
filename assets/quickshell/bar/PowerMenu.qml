import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "blocks"
import "power"
import ".."

Rectangle {
    id: powerWidget
    height: parent.height
    implicitWidth: powerDisplay.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        id: powerDisplay
        spacing: 5
        height: parent.height - ShellGlobals.props.universalPadding
        anchors.centerIn: parent

        FancyIconText {
            scaling: 0.75
            text: "⏻"
            color: ShellGlobals.colors.powerColor
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            monitorRoot.toggleWidget("power")
        }
    }

    PopupWindow {
        id: popup
        visible: monitorRoot.openWidget === "power"
        color: "transparent"
        anchor.window: window
        anchor.rect.x: 9999999;
        anchor.rect.y: window.height
        implicitWidth: popupDisplay.width
        implicitHeight: popupDisplay.height

        Rectangle {
            id: popupDisplay
            height: 130
            width: 160 + ShellGlobals.props.universalPadding
            color: ShellGlobals.colors.widget
            radius: ShellGlobals.props.widgetRounding
            border.color: ShellGlobals.colors.widgetOutline
            border.width: 3

            ScrollView {
                anchors.fill: parent
                contentWidth: availableWidth

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    PowerMenuAction {
                        icon: "󰒲"
                        action: qsTr("Suspend")
                        command: ShellGlobals.actions.suspend
                    }

                    PowerMenuAction {
                        icon: "󰜉"
                        action: qsTr("Reboot")
                        command: ShellGlobals.actions.reboot
                    }

                    PowerMenuAction {
                        icon: "󰍃"
                        action: qsTr("Logout")
                        command: ShellGlobals.actions.logout
                    }

                    PowerMenuAction {
                        icon: ""
                        action: qsTr("Shutdown")
                        command: ShellGlobals.actions.shutdown
                    }
                }
            }
        }
    }
}
