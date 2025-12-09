import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell.Widgets
import Quickshell.Services.Pipewire

import "../.."
import "../blocks"

ColumnLayout {
	required property PwNode node;

    property var nodeName: null

    width: 400

	PwObjectTracker { objects: [ node ] }

	RowLayout {
        spacing: 10

        FancyIconText {
            id: volumeIcon
            text: root.getVolumeIcon(Math.floor(node.audio.volume * 100), node.audio.muted)
            scaling: 0.8
            color: ShellGlobals.colors.commonTextColor

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: node.audio.muted = !node.audio.muted
            }
        }

		FancyText {
			text: {
				const app = nodeName ?? node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
				const media = node.properties["media.name"];
                if (media !== undefined && app.toLowerCase() === media.toLowerCase())
                    return limitLength(media, 32);
                const combined = media != undefined ? `${app} - ${media}` : app;
				return limitLength(combined, 32);
			}
            color: ShellGlobals.colors.commonTextColor
            font.pixelSize: 16
		}
	}

	RowLayout {
        spacing: 20
        width: parent.width

		Slider {
            id: volumeSlider
			Layout.preferredWidth: 220
			value: Math.min(1, node.audio.volume)
            from: 0
            to: 1
            stepSize: 0.01

            handle: Rectangle {
                width: 14
                height: width
                color: ShellGlobals.colors.commonTextColor
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: (volumeSlider.value / volumeSlider.to) * (volumeSlider.width - width)

                Behavior on anchors.left {
                    NumberAnimation { duration: 100 }
                }
            }

			onValueChanged: node.audio.volume = value
		}

		Slider {
            id: volumeBoostSlider
			Layout.preferredWidth: 100
			value: Math.max(0, node.audio.volume - 1)
            from: 0
            to: 1
            stepSize: 0.01
            enabled: node.audio.volume >= 1

            handle: Rectangle {
                width: 14
                height: width
                color: ShellGlobals.colors.commonTextColor
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: (volumeBoostSlider.value / volumeBoostSlider.to) * (volumeBoostSlider.width - width)

                Behavior on anchors.left {
                    NumberAnimation { duration: 100 }
                }
            }

            background: Rectangle {
                x: volumeBoostSlider.leftPadding
                y: volumeBoostSlider.topPadding + volumeBoostSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: volumeBoostSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: volumeBoostSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }

			onValueChanged: {
                node.audio.volume = 1 + value
            }
		}

		FancyText {
			text: `${Math.floor(node.audio.volume * 100)}%`
            color: ShellGlobals.colors.commonTextColor
            font.pixelSize: 12
		}
	}

    function limitLength(str, max) {
        if (!str) return "Unknown Speaker";
        if (str.length > max) return str.substring(0, max).trim() + "…";
        return str;
    }
}
