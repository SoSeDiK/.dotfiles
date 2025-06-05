import Quickshell

import QtQuick
import QtQuick.Controls

import "../.."

Text {
    required property SystemClock _clock
    property var dateInfo: getDateInfo(_clock.date)

    text: dateInfo.icon
    color: ShellGlobals.colors.widget
    font.family: ShellGlobals.fonts.iconFontFamily
    font.weight: Font.Bold
    font.pixelSize: parent.height * 0.85

    ToolTip {
        id: tooltip
        text: dateInfo.name || ""

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

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (tooltip.text === "") return;

            tooltip.visible = true
            tooltip.x = parent.x - tooltip.width - ShellGlobals.props.universalPadding
            tooltip.y = parent.y - (ShellGlobals.props.universalPadding / 2)
        }

        onExited: {
            tooltip.visible = false
        }
    }

    readonly property var holidayMap: {
        '01-01': { name: "New Year's Day", icon: "" },
        '02-14': { name: "Valentine's Day", icon: "󰧒" },
        '03-08': { name: "International Women's Day", icon: "󱗎" },
        '03-14': { name: "Pi Day", icon: "" },
        '03-17': { name: "St. Patrick's Day", icon: "󰠖" },
        '03-18': { name: "Happy Birthday!", icon: "" },
        '04-01': { name: "April Fools", icon: "󰧓" },
        '04-02': { name: "World Autism Awareness Day", icon: "∞" },
        '04-22': { name: "Earth Day", icon: "󰇧" },
        '04-26': { name: "Alien Day", icon: "󰢚" },
        '05-01': { name: "International Workers' Day", icon: "󱢇" },
        '05-09': { name: "Victory Day over Nazism in World War Ⅱ", icon: "卐" },
        '06-01': { name: "Pride Month", icon: "🏳️‍🌈" },
        '06-05': { name: "World Environment Day", icon: "" },
        '07-02': { name: "World UFO Day", icon: "󱃄" },
        '08-24': { name: "Independence Day of Ukraine", icon: "🇺🇦" },
        '09-11': { name: "9/11", icon: "󰦑󰦑" },
        '09-19': { name: "International Talk Like a Pirate Day", icon: "󰨈" },
        '09-21': { name: "International Day of Peace", icon: "" },
        '10-31': { name: "Halloween", icon: "󰊠" },
        '11-01': { name: "Day of the Dead", icon: "" },
        '12-06': { name: "Saint Nicholas Day", icon: "" },
        '12-25': { name: "Christmas", icon: "" },
        '12-31': { name: "New Year's Eve", icon: "󰧓" },
    };

    function getDateInfo(date) {
        if (isEaster(date)) return { name: "Easter", icon: "󰪰" }
        if (isUSThanksgiving(date, 0)) return { name: "Thanksgiving (United States)", icon: "󱜛" }
        if (isUSThanksgiving(date, 1)) return { name: "Black Friday", icon: "󰑯" }
        if (isUSThanksgiving(date, 4)) return { name: "Cyber Monday", icon: "" }
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const dateKey = `${month}-${day}`;
        const holiday = holidayMap[dateKey];
        return holiday ? holiday : { name: null, icon: "󰃭" };
    }

    function isEaster(date) {
        var Y = date.getFullYear()
        var C = Math.floor(Y / 100);
        var N = Y - 19 * Math.floor(Y / 19);
        var K = Math.floor((C - 17) / 25);
        var I = C - Math.floor(C / 4) - Math.floor((C - K) / 3) + 19 * N + 15;
        I = I - 30 * Math.floor(I / 30);
        I = I - Math.floor(I / 28) * (1 - Math.floor(I / 28) * Math.floor(29 / (I + 1)) * Math.floor((21 - N) / 11));
        var J = Y + Math.floor(Y / 4) + I + 2 - C + Math.floor(C / 4);
        J = J - 7 * Math.floor(J / 7);
        var L = I - J;
        var M = 3 + Math.floor((L + 40) / 44);
        var D = L + 28 - 31 * Math.floor(M / 4);
        return M === date.getMonth() + 1 && D === date.getDate();
    }

    function isUSThanksgiving(date, offset) {
        if (date.getMonth() !== 10) return false;

        const thanksgivingInUSDate = getUSThanksgivingDate(date.getFullYear());
        const offsetDate = new Date(thanksgivingInUSDate);
        offsetDate.setDate(thanksgivingInUSDate.getDate() + offset);

        return date.getDate() === offsetDate.getDate();
    }

    function getUSThanksgivingDate(year) {
        // Calculate the fourth Thursday of November
        const thanksgivingInUSDate = new Date(year, 10, 1);
        const firstDayOfNovember = thanksgivingInUSDate.getDay();
        const fourthThursday = 22 + (firstDayOfNovember <= 4 ? 4 - firstDayOfNovember : 11 - firstDayOfNovember);
        return new Date(year, 10, fourthThursday);
    }
}
