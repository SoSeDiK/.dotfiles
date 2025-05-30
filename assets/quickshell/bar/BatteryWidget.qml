import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "blocks"
import ".."

Rectangle {
	readonly property var chargeState: UPower.displayDevice.state
	readonly property bool isCharging: chargeState == UPowerDeviceState.Charging;
	readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge;
	readonly property real percentage: Math.floor(UPower.displayDevice.percentage * 100)
	readonly property bool isLow: percentage <= ShellGlobals.props.batteryLowLevel

	readonly property UPowerDevice batteryDevice: UPower.devices.values
		.find(device => device.isLaptopBattery);

    readonly property var batteryIcons: {
            100: "󰁹",
            90: "󰂂",
            80: "󰂁",
            70: "󰂀",
            60: "󰁿",
            50: "󰁾",
            40: "󰁽",
            30: "󰁼",
            20: "󰁻",
            10: "󰁺",
            0: "󱃍",
        };
    readonly property var chargingBatteryIcons: {
            101: "󰂄",
            100: "󰂅",
            90: "󰂋",
            80: "󰂊",
            70: "󰢞",
            60: "󰂉",
            50: "󰢝",
            40: "󰂈",
            30: "󰂇",
            20: "󰂆",
            10: "󰢜",
            0: "󰢟",
        }

    id: batteryWidget
    height: parent.height
    implicitWidth: batteryDisplay.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        id: batteryDisplay
        spacing: 5
        height: parent.height - ShellGlobals.props.universalPadding
        anchors.centerIn: parent

        FancyIconText {
            scaling: 0.6
            text: "󰌪"
            color: ShellGlobals.colors.batteryColor
            visible: PowerProfiles.profile === PowerProfile.PowerSaver
        }

        FancyIconText {
            scaling: 0.6
            text: ""
            color: ShellGlobals.colors.batteryColor
            visible: PowerProfiles.profile === PowerProfile.Performance
        }

        FancyText {
            text: formatBattery(percentage, isCharging, isPluggedIn)
            color: isLow ? ShellGlobals.colors.batteryLowColor : ShellGlobals.colors.batteryColor
        }
    }

    function formatBattery(
        level,
        charging,
        charged
    ) {
        level = Math.max(level, 1);
        if (charged) {
            const conservationMode = level <= 95;
            const batteryIcon = conservationMode ? chargingBatteryIcons[101] : batteryIcons[100];
            return `${batteryIcon} ${level}%`;
        }

        const batteryIcon = getClosestBatteryLevel(level, charging)
        return `${batteryIcon} ${level}%`;
    }

    function getClosestBatteryLevel(level, charging) {
        const array = !charging ? batteryIcons : chargingBatteryIcons;
        const levels = Object.keys(array)
            .map(Number)
            .sort((a, b) => b - a);
        for (let i = 0; i < levels.length; i++) {
            if (level >= levels[i]) {
            return array[levels[i]];
            }
        }
        return array[levels[levels.length - 1]];
    }
}
