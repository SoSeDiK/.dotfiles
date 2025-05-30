import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "audio"
import "blocks"
import ".."

Rectangle {
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    id: audioWidget
    height: parent.height
    implicitWidth: audioDisplay.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        id: audioDisplay
        spacing: 5
        height: parent.height - ShellGlobals.props.universalPadding
        anchors.centerIn: parent

        FancyIconText {
            id: muteDisplay
            scaling: 0.75
            text: "󰍭"
            color: ShellGlobals.colors.audioColor
            visible: source.audio.muted
        }

        FancyIconText {
            id: volumeIcon
            text: root.getVolumeIcon(volumeIpc.getVolume(), sink.audio.muted)
            color: ShellGlobals.colors.audioColor
        }

        FancyText {
            id: volumeText
            text: volumeIpc.getVolume() + "%"
            color: ShellGlobals.colors.audioColor
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            monitorRoot.toggleWidget("audio")
        }
    }

    PwObjectTracker { objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource ] }

    IpcHandler {
        id: volumeIpc
        target: "volume"

        function setVolume(str: string): void { 
            if (str.length > 0 && (str[0] === "+" || str[0] === "-")) {
                if (str[0] === "+") {
                    sink.audio.volume += (parseInt(str.slice(1)) / 100);
                } else {
                    sink.audio.volume -= (parseInt(str.slice(1)) / 100);
                }

            } else {
                sink.audio.volume = (parseInt(str) / 100);
            }
        }

        function getVolume(): int { return Math.floor(sink.audio.volume * 100); }
        function toggleMute(): void { sink.audio.muted = !sink.audio.muted; }
        function toggleMic(): void { source.audio.muted = !source.audio.muted; }
    }

    PopupWindow {
        id: audioPopup
        visible: monitorRoot.openWidget === "audio"
        color: "transparent"
        anchor.window: window
        anchor.rect.x: 9999999;
        anchor.rect.y: window.height
        implicitWidth: audioPopupDisplay.width
        implicitHeight: audioPopupDisplay.height

        Rectangle {
            id: audioPopupDisplay
            height: 400
            width: 400 + ShellGlobals.props.universalPadding
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

                    RowLayout {
                        spacing: 10

                        FancyIconText {
                            text: ""
                            color: ShellGlobals.colors.commonTextColor
                            font.pixelSize: 18

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    monitorRoot.toggleWidget("audio")
                                    audioMixerApp.running = true
                                }
                            }
                        }
                        
                        FancyText {
                            text: qsTr("Volume Mixer")
                            color: ShellGlobals.colors.commonTextColor
                            font.pixelSize: 18
                        }
                    }

                    // PwNodeLinkTracker {
                    //     id: linkTracker
                    //     node: Pipewire.defaultAudioSink
                    // }

                    MixerEntry {
                        node: Pipewire.defaultAudioSink
                        nodeName: qsTr("Speaker")
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        color: palette.active.text
                        implicitHeight: 1
                    }

                    Repeater {
                        model: {
                            return Pipewire.linkGroups.values
                                // Only apps
                                .filter((node) => node.source && node.source.audio && !node.source.isSink && node.source.isStream)
                                // Deduplicate
                                .filter((item, index, self) => index === self.findIndex(t => t.source.id === item.source.id));
                        }

                        MixerEntry {
                            required property PwLinkGroup modelData
                            node: modelData.source
                        }
                    }
                }
            }
        }
    }

    Process {
        id: audioMixerApp
        command: [ShellGlobals.apps.audioMixerApp]
        running: false
    }
}
