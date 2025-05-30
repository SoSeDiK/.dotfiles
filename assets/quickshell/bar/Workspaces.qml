import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "blocks"
import "clock"
import ".."

Rectangle {
    required property var _screen
    property HyprlandMonitor monitor: Hyprland.monitorFor(_screen)

    property var specialWsName: null
    property var specialWs: null
    property var workspaceData

    height: parent.height
    implicitWidth: workspacesDisplay.width + ShellGlobals.props.universalPadding
    color: ShellGlobals.colors.widget
    radius: ShellGlobals.props.widgetRounding

    RowLayout {
        id: workspacesDisplay
        height: parent.height
        anchors.centerIn: parent
        spacing: ShellGlobals.props.universalPadding / 2

        Repeater {
            model: ScriptModel {
                values: {
                    if (!workspaceData) return [];

                    specialWs = null;

                    const workspaces = Array.from({ length: 10 }, (_, id) => ([(monitor.id * 10 + id) + 1, null]));

                    [...Hyprland.workspaces.values]
                        .filter((ws) => {
                            if (ws.monitor !== monitor) return false;
                            if (ws.name.startsWith("special")) {
                                if (ws.name === specialWsName)
                                    specialWs = ws;
                                return false;
                            }

                            return true;
                        })
                        .forEach((ws) => {
                            const index = (ws.id - 1) % 10;
                            workspaces[index][1] = ws;
                        });

                    return workspaces;
                }
            }

            delegate: RowLayout {
                property int wsNum: modelData[0]
                property HyprlandWorkspace ws: modelData[1]

                height: parent.height - ShellGlobals.props.universalPadding
                implicitWidth: workspaceDisplay.width + repeater.width
                spacing: 5

                ClockDigit {
                    property bool down: false
                    property bool hovering: false
                    property string wsColor: hovering ? (down ? ShellGlobals.colors.workspaceActivePressedTextColor : ShellGlobals.colors.workspaceActiveHovereredTextColor) : (wsNum === monitor.activeWorkspace?.id ? ShellGlobals.colors.workspaceActiveTextColor : (ws ? ShellGlobals.colors.workspaceTextColor : ShellGlobals.colors.workspaceEmptyTextColor))

                    id: workspaceDisplay
                    text: getWorkspaceName(wsNum)
                    color: wsColor
                    font.pixelSize: 0.8 * Math.min(ShellGlobals.props.barHeight, parent.height)
                    y: -(height - font.pixelSize) / 4

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: {
                            workspaceDisplay.hovering = true 
                        }

                        onExited: {
                            workspaceDisplay.hovering = false
                        }

                        onPressed: {
                            workspaceDisplay.down = true;
                        }

                        onReleased: {
                            workspaceDisplay.down = false;
                        }

                        onClicked: {
                            if (wsNum !== monitor.activeWorkspace?.id)
                                Hyprland.dispatch(`workspace ${wsNum}`);
                        }
                    }
                }

                Repeater {
                    id: repeater
                    model: ScriptModel {
                        values: ws ? getChunks(ws) : []
                    }

                    Item {
                        height: parent.height
                        implicitWidth: appIcon.width

                        property var appData: root.filterTitle(modelData.class, modelData.title, true)

                        ClockIcon {
                            id: appIcon
                            text: appData[0]
                            color: ShellGlobals.colors.workspaceTextColor
                            font.pixelSize: 0.8 * Math.min(ShellGlobals.props.barHeight, parent.height)
                            y: -(height - font.pixelSize) / 4

                            ToolTip {
                                id: tooltip
                                height: 30
                                text: getTitle(modelData, appData[1])

                                contentItem: Rectangle {
                                    height: parent.height - ShellGlobals.props.universalPadding
                                    width: tooltipText.width - ShellGlobals.props.universalPadding
                                    color: "transparent"

                                    FancyText {
                                        id: tooltipText
                                        text: tooltip.text
                                        color: ShellGlobals.colors.timeTextColor
                                    }
                                }

                                background: Rectangle {
                                    radius: ShellGlobals.props.widgetRounding
                                    color: ShellGlobals.colors.widget
                                    border.color: ShellGlobals.colors.widgetOutline
                                    border.width: 2
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    if (tooltip.text === "") return;

                                    tooltip.visible = true
                                    tooltip.x = parent.x + parent.width + ShellGlobals.props.universalPadding
                                    tooltip.y = parent.y - (ShellGlobals.props.universalPadding / 2)
                                }

                                onExited: {
                                    tooltip.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            property bool down: false
            property bool hovering: false

            id: specialWorkspaceDisplay
            height: parent.height - (ShellGlobals.props.universalPadding / 2)
            implicitWidth: specialWorkspaceIcon.width + ShellGlobals.props.universalPadding
            color: hovering ? (down ? ShellGlobals.colors.workspaceSpecialPressedBackground : ShellGlobals.colors.workspaceSpecialHoveredBackground) : ShellGlobals.colors.workspaceSpecialBackground
            radius: 4
            border.width: 2
            border.color: ShellGlobals.colors.widgetOutline
            visible: specialWs != null

            ClockDigit {
                id: specialWorkspaceIcon
                text: getSpecialLabel(specialWs?.name || "")
                color: ShellGlobals.colors.workspaceEmptyTextColor
                font.pixelSize: 0.75 * Math.min(ShellGlobals.props.barHeight, parent.height)
                y: -(height - font.pixelSize) / 4
                anchors.centerIn: parent

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: {
                        specialWorkspaceDisplay.hovering = true 
                    }

                    onExited: {
                        specialWorkspaceDisplay.hovering = false
                    }

                    onPressed: {
                        specialWorkspaceDisplay.down = true;
                    }

                    onReleased: {
                        specialWorkspaceDisplay.down = false;
                    }

                    onClicked: {
                        if (specialWsName)
                            Hyprland.dispatch(`togglespecialworkspace ${specialWsName.replace("special:", "")}`);
                    }
                }
            }
        }
    }

    function transformData(data, keysToKeep) {
        const result = {};

        data.forEach(item => {
            const workspaceId = item.workspace.id;
            const entry = {};

            keysToKeep.forEach(key => {
                if (item[key] !== undefined) {
                    entry[key] = item[key];
                }
            });

            if (!result[workspaceId]) {
                result[workspaceId] = [];
            }

            result[workspaceId].push(entry);
        });

        const currentWorkspaceId = monitor.activeWorkspace?.id;

        let showBackground = currentWorkspaceId && result[currentWorkspaceId];
        if (showBackground) {
            showBackground = false;
            for (const [index, app] of result[currentWorkspaceId].entries()) {
                if (!app.floating) {
                    showBackground = true;
                    break;
                }
            }
        }

        monitorRoot.backgroundColor = showBackground ? "#FF212223" : "transparent";

        return result;
    }

    function getChunks(ws) {
        let chunks = [];
        if (!workspaceData) return chunks;

        var apps = workspaceData[ws.id];
        if (!apps) return chunks;

        apps.forEach(app => {
            if (app.title !== "")
                chunks.push(app);
        });

        return chunks;
    }

    function getWorkspaceName(wsNum) {
        wsNum = wsNum % 10;
        switch (wsNum) {
            case 1:
                return 'Ⅰ';
            case 2:
                return 'Ⅱ';
            case 3:
                return 'Ⅲ';
            case 4:
                return 'Ⅳ';
            case 5:
                return 'Ⅴ';
            case 6:
                return 'Ⅵ';
            case 7:
                return 'Ⅶ';
            case 8:
                return 'Ⅷ';
            case 9:
                return 'Ⅸ';
            case 0:
                return 'Ⅹ';
            default:
                return 'Ⅼ'
        }
    }

    function getSpecialLabel(workspace) {
        workspace = workspace.replace("special:", "");
        switch (workspace) {
            case "private":
                return "󰗹";
            case "notes":
                return "󰴓";
            case "discord":
                return "󰙯";
            case "telegram":
                return "";
            case "temp":
                return "";
            case "music":
                return "󰎇";
            case "calculator":
                return "";
            default:
                return workspace;
        }
    }

    function getTitle(client, title) {
        const originalTitle = client.title;
        return originalTitle.includes(title) ? originalTitle : title + " – " + originalTitle;
    }

    Socket {
        id: hyprlandRequestSocket
        connected: false
        path: Hyprland.requestSocketPath
        parser: SplitParser {
            splitMarker: ""
            onRead: data => {
                hyprlandRequestSocket.connected = false;
                var jsonData = JSON.parse(data);

                const keysToKeep = ['address', 'class', 'title', 'floating'];
                workspaceData = transformData(jsonData, keysToKeep);
            }
        }
    }

    Component.onCompleted: {
        triggerWorkspacesRefresh();
        Hyprland.rawEvent.connect(hyprlandEvent);
    }

    function hyprlandEvent(event) {
        const eventName = event.name;
        if (eventName === "activespecial") {
            specialWsName = event.parse(2)[0];
            if (specialWsName === "")
                specialWsName = null;
        }
        if (triggerUpdate(eventName)) {
            triggerWorkspacesRefresh();
        }
    }

    function triggerUpdate(event) {
        return event === "workspace"
            || event === "activespecial"
            || event === "openwindow"
            || event === "closewindow"
            || event === "movewindow"
            || event === "changefloatingmode";
    }

    function triggerWorkspacesRefresh() {
        hyprlandRequestSocket.connected = true;
        hyprlandRequestSocket.write("j/clients");
        hyprlandRequestSocket.flush();
    }
}
