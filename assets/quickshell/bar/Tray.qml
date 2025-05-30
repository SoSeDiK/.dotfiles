import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."

Rectangle {
    height: parent.height
    implicitWidth: tray.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        id: tray
        spacing: 5
        height: parent.height - ShellGlobals.props.universalPadding
        anchors.centerIn: parent

        Repeater {
            model: ScriptModel {
                values: {
                  [...SystemTray.items.values]
                    .filter((item) => {
                        return (item.id != "spotify-client")
                    })
                }
            }

            MouseArea {
                id: delegate
                required property SystemTrayItem modelData
                property alias item: delegate.modelData

                height: parent.height
                implicitWidth: icon.implicitWidth + 5

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                hoverEnabled: true

                onClicked: event => {
                    if (event.button == Qt.LeftButton) {
                        menuAnchor.open();
                    } else if (event.button == Qt.MiddleButton) {
                        item.secondaryActivate();
                    } else if (event.button == Qt.RightButton) {
                        item.activate();
                    }
                }

                onWheel: event => {
                    event.accepted = true;
                    const points = event.angleDelta.y / 120
                    item.scroll(points, false);
                }

                IconImage {
                    id: icon
                    anchors.centerIn: parent
                    source: item.icon
                    implicitSize: 16
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: item.menu

                    anchor.window: delegate.QsWindow.window
                    anchor.adjustment: PopupAdjustment.Flip

                    anchor.onAnchoring: {
                        const window = delegate.QsWindow.window;
                        const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);

                        menuAnchor.anchor.rect = widgetRect;
                    }
                }

                ToolTip {
                    id: tooltip
                    text: delegate.item.tooltipTitle || delegate.item.id

                    contentItem: Text {
                            text: tooltip.text
                            font: tooltip.font
                            color: ShellGlobals.colors.timeTextColor
                    }

                    background: Rectangle {
                            radius: ShellGlobals.props.widgetRounding
                            color: ShellGlobals.colors.widget
                            border.color: ShellGlobals.colors.widgetOutline
                    }
                }

                onEntered: {
                        tooltip.visible = true
                        tooltip.x = -tooltip.width - ShellGlobals.props.universalPadding
                }

                onExited: {
                        tooltip.visible = false
                }
            }
        }
    }
}
