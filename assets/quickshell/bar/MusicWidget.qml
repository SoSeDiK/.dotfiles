import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."
import "audio"
import "mpris"

Rectangle {
    height: parent.height
    implicitWidth: musicWidget.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        readonly property string playTrack: ""
        readonly property string pauseTrack: ""
        readonly property string previousTrack: "󰒮"
        readonly property string nextTrack: "󰒭"
        readonly property int borderWidth: 4
        readonly property string noCoverPlaceholder: "󰋒"

        property real progress: MprisController.progress

        id: musicWidget
        height: parent.height
        anchors.centerIn: parent
        spacing: ShellGlobals.props.universalPadding / 2

        Rectangle {
            id: coverArt
            height: parent.height - (ShellGlobals.props.universalPadding / 2)
            width: height
            radius: ShellGlobals.props.widgetRounding
            color: ShellGlobals.colors.widgetOutline

            Text {
                text: musicWidget.noCoverPlaceholder
                anchors.centerIn: parent
                color: ShellGlobals.colors.widget
                font.family: ShellGlobals.fonts.iconFontFamily
                font.weight: Font.Bold
                font.pixelSize: parent.height * 0.75
            }

            ClippingRectangle {
                height: parent.height - musicWidget.borderWidth
                width: height
                anchors.centerIn: parent
                radius: ShellGlobals.props.widgetRounding

                Image {
                    id: sourceItem
                    anchors.centerIn: parent
                    source: MprisController.activePlayer?.trackArtUrl ?? ""
                    height: parent.height - musicWidget.borderWidth
                    width: height
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Hyprland.dispatch("togglespecialworkspace music");
                }
            }
        }

        MediaPlaybackButton {
            text: musicWidget.previousTrack

            onClicked: {
                MprisController.previous()
            }
        }

        MediaPlaybackButton {
            id: controlButton
            text: MprisController.isPlaying ? musicWidget.pauseTrack : musicWidget.playTrack
            implicitHeight: parent.height - ShellGlobals.props.universalPadding
            scaleMultiplier: 0.8

            background: Canvas {
                id: progressCanvas
                implicitHeight: controlButton.height
                implicitWidth: height

                onPaint: {
                    var ctx = progressCanvas.getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var radius = Math.min(width, height) / 2;
                    var centerX = width / 2;
                    var centerY = height / 2;

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                    ctx.fillStyle = ShellGlobals.colors.mediaProgressBackground;
                    ctx.fill();

                    ctx.beginPath();
                    ctx.moveTo(centerX, centerY);
                    ctx.arc(centerX, centerY, radius, -Math.PI / 2, (2 * Math.PI * musicWidget.progress) - Math.PI / 2);
                    ctx.closePath();
                    ctx.fillStyle = ShellGlobals.colors.mediaProgress;
                    ctx.fill();
                }
            }

            onClicked: {
                MprisController.togglePlaying()
            }
        }

        MediaPlaybackButton {
            text: musicWidget.nextTrack

            onClicked: {
                MprisController.next()
            }
        }

        onProgressChanged: {
            progressCanvas.requestPaint();
        }
    }
}
