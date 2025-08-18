//@ pragma UseQApplication

import Quickshell
import Quickshell.Wayland

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Scope {
            property var modelData

            id: monitorRoot

            PanelWindow {
                property var wh: 5

                id: window
                screen: modelData
                surfaceFormat.opaque: false

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }

                // implicitHeight: 0
                // color: "#FFFFFF"

                color: "transparent"

                mask: Region {}
                WlrLayershell.layer: WlrLayer.Overlay


                Rectangle {
                    implicitHeight: window.wh
                    implicitWidth: parent.width
                    color: "#FFFFFF"
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            window.wh = 20
                        }
                        onExited: {
                            window.wh = 0
                        }
                    }
                }
                Rectangle {
                    implicitHeight: window.wh
                    implicitWidth: parent.width
                    color: "#FFFFFF"
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            window.wh = 20
                        }
                        onExited: {
                            window.wh = 0
                        }
                    }
                }
                Rectangle {
                    implicitHeight: parent.height
                    implicitWidth: window.wh
                    color: "#FFFFFF"
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            window.wh = 20
                        }
                        onExited: {
                            window.wh = 0
                        }
                    }
                }
                Rectangle {
                    implicitHeight: parent.height
                    implicitWidth: window.wh
                    color: "#FFFFFF"
                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                    }
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            window.wh = 20
                        }
                        onExited: {
                            window.wh = 0
                        }
                    }
                }


                // Behavior on height {
                //     NumberAnimation {
                //         duration: 200
                //     }
                // }

                // MouseArea {
                //     anchors.fill: parent

                //     hoverEnabled: true

                //     onEntered: {
                //         window.implicitHeight = 150
                //     }

                //     onExited: {
                //         window.implicitHeight = 0
                //     }
                // }
            }
        }
    }
}
