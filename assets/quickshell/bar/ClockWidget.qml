import Quickshell
import Quickshell.Io

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ".."
import "clock"

Item {
    required property SystemClock _clock

    id: clockWidget
    implicitWidth: layout.implicitWidth
    height: ShellGlobals.props.barHeight

    RowLayout {
        id: layout
        spacing: 0
        height: parent.height

        Rectangle {
            id: leftPart
            color: ShellGlobals.colors.timeTextColor
            topLeftRadius: ShellGlobals.props.widgetRounding
            bottomLeftRadius: ShellGlobals.props.widgetRounding
            implicitWidth: clockIcon.implicitWidth + ShellGlobals.props.universalPadding
            height: parent.height
            Layout.alignment: Qt.AlignVCenter

            Item {
                implicitWidth: clockIcon.implicitWidth
                height: parent.height - ShellGlobals.props.universalPadding
                anchors.centerIn: parent

                ClockIcon {
                    id: clockIcon
                    hour: _clock.hours
                    y: 1
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: clockApp.running = true
            }
        }

        Rectangle {
            id: rightPart
            color: ShellGlobals.colors.widget
            topRightRadius: ShellGlobals.props.widgetRounding
            bottomRightRadius: ShellGlobals.props.widgetRounding
            implicitWidth: timeLoader.implicitWidth + ShellGlobals.props.universalPadding
            height: parent.height
            clip: true

            Loader {
                id: timeLoader
                sourceComponent: ShellGlobals.props.focusMode ? stillClock : animatedClock
                height: parent.height - ShellGlobals.props.universalPadding
                anchors.centerIn: parent
            }

            Component {
                id: stillClock

                RowLayout {
                    spacing: ShellGlobals.props.universalPadding / 2
                    height: parent.height
                    
                    ClockDigit {
                        id: one
                        text: Qt.formatDateTime(_clock.date, "hh:mm")
                    }
                    ClockDigit {
                        id: two
                        text: ""
                        font.family: ShellGlobals.fonts.iconFontFamily
                        font.pixelSize: parent.height * 0.7
                    }
                }
            }

            Component {
                id: animatedClock

                RowLayout {
                    spacing: 0
                    height: parent.height

                    AnimatedClockDigit {
                        currentDigit: _clock.hours / 10
                    }
                    AnimatedClockDigit {
                        currentDigit: _clock.hours % 10
                    }

                    ClockDigit {
                        text: ":"
                    }

                    AnimatedClockDigit {
                        currentDigit: _clock.minutes / 10
                    }
                    AnimatedClockDigit {
                        currentDigit: _clock.minutes % 10
                    }

                    ClockDigit {
                        text: ":"
                    }

                    AnimatedClockDigit {
                        currentDigit: _clock.seconds / 10
                    }
                    AnimatedClockDigit {
                        currentDigit: _clock.seconds % 10
                    }
                }
            }
        }
    }

    Process {
        id: clockApp
        command: [ShellGlobals.apps.clockApp]
        running: false
    }
}
