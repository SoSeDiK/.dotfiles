import Quickshell

import QtQuick
import QtQuick.Layouts

import ".."
import "clock"

Item {
    required property SystemClock _clock

    id: dateWidget
    implicitWidth: layout.implicitWidth
    height: parent.height

    RowLayout {
        id: layout
        spacing: 0
        height: parent.height

        Rectangle {
            id: leftPart
            color: ShellGlobals.colors.timeTextColor
            topLeftRadius: ShellGlobals.props.widgetRounding
            bottomLeftRadius: ShellGlobals.props.widgetRounding
            implicitWidth: dateIcon.implicitWidth + ShellGlobals.props.universalPadding
            height: parent.height
            Layout.alignment: Qt.AlignVCenter

            Item {
                implicitWidth: dateIcon.implicitWidth
                height: parent.height - ShellGlobals.props.universalPadding
                anchors.centerIn: parent

                CalendarIcon {
                    _clock: dateWidget._clock
                    id: dateIcon
                }
            }
        }

        Rectangle {
            id: rightPart
            color: ShellGlobals.colors.widget
            topRightRadius: ShellGlobals.props.widgetRounding
            bottomRightRadius: ShellGlobals.props.widgetRounding
            implicitWidth: dateText.implicitWidth + ShellGlobals.props.universalPadding
            height: parent.height
            Layout.alignment: Qt.AlignVCenter

            Item {
                implicitWidth: dateText.implicitWidth
                height: parent.height - ShellGlobals.props.universalPadding
                anchors.centerIn: parent

                ClockDigit {
                    property var date: _clock.date

                    id: dateText
                    text: Qt.locale().toString(date, "ddd ") + Qt.locale().toString(date, "MMM").substring(0, 3) + Qt.locale().toString(date, " dd")
                }
            }
        }
    }
}
