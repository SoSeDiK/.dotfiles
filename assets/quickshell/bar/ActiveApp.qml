import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "clock"
import ".."

RowLayout {
    required property var _root
    property var activeWindow: ["", ""]

    id: layout
    height: parent.height
    implicitWidth: appName.width + ShellGlobals.props.universalPadding
    spacing: 0
    visible: activeWindow[1] !== ""

    Rectangle {
        id: leftPart
        color: ShellGlobals.colors.timeTextColor
        topLeftRadius: ShellGlobals.props.widgetRounding
        bottomLeftRadius: ShellGlobals.props.widgetRounding
        implicitWidth: appIcon.implicitWidth + ShellGlobals.props.universalPadding
        height: parent.height
        Layout.alignment: Qt.AlignVCenter

        Item {
            implicitWidth: appIcon.implicitWidth
            height: parent.height - ShellGlobals.props.universalPadding
            anchors.centerIn: parent

            ClockIcon {
                id: appIcon
                text: activeWindow[0]
            }
        }
    }

    Rectangle {
        id: rightPart
        color: ShellGlobals.colors.widget
        topRightRadius: ShellGlobals.props.widgetRounding
        bottomRightRadius: ShellGlobals.props.widgetRounding
        implicitWidth: appName.implicitWidth + ShellGlobals.props.universalPadding
        height: parent.height
        Layout.alignment: Qt.AlignVCenter

        Item {
            implicitWidth: appName.implicitWidth
            height: parent.height - ShellGlobals.props.universalPadding
            anchors.centerIn: parent

            ClockDigit {
                id: appName
                text: activeWindow[1]
            }
        }
    }

    Component.onCompleted: {
        Hyprland.rawEvent.connect(hyprlandEvent);
    }

    function hyprlandEvent(event) {
        if (event.name !== "activewindow") return;

        const data = event.parse(2);
        activeWindow = _root.filterTitle(data[0], data[1], false);
    }
}
