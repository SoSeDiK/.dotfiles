//@ pragma UseQApplication
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import ".."
import "bar" as Bar

ShellRoot {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Variants {
        model: Quickshell.screens

        Scope {
            property var modelData
            property color backgroundColor: "#FF212223"
            property string openWidget: ""

            id: monitorRoot

            function toggleWidget(widget: string) {
                openWidget = openWidget === widget ? "" : widget;
            }

            PanelWindow {
                id: window
                screen: modelData
                HyprlandWindow.opacity: 0.9999 // Does not render transparency correctly otherwise

                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 36 // TODO: for whatever reason the bar height is not set properly via globals
                // implicitHeight: ShellGlobals.props.barHeight + ShellGlobals.props.universalPadding + ShellGlobals.props.barOffset
                color: monitorRoot.backgroundColor

                Item {
                    anchors.centerIn: parent
                    width: parent.width - ShellGlobals.props.universalPadding
                    height: ShellGlobals.props.barHeight

                    // Left section
                    RowLayout {
                        id: left_section
                        anchors.left: parent.left
                        height: parent.height
                        spacing: 10

                        Bar.Workspaces {
                            _screen: window.screen
                        }
                        Bar.ActiveApp {
                            _root: root
                        }
                    }

                    // Center section
                    RowLayout {
                        id: center_section
                        anchors.centerIn: parent
                        height: parent.height
                        spacing: 10

                        Bar.KbLayout {}
                        Bar.DateWidget {
                            _clock: clock
                        }
                        Bar.ClockWidget {
                            _clock: clock
                        }
                        Bar.MusicWidget {}
                    }

                    // Right section
                    RowLayout {
                        id: right_section
                        anchors.right: parent.right
                        height: parent.height
                        spacing: 10

                        Bar.Tray {}
                        Bar.AudioWidget {}
                        Bar.BatteryWidget {}
                        Bar.PowerMenu {}
                    }
                }
            }
        }
    }

    function filterTitle(clazz, title, formatClass) {
        const windowTitleMap = [
            ["kitty", ["󰄛", "Kitty"]],
            ["codium", ["", "VSCodium"]],
            ["firefox", ["󰈹", "Firefox"]],
            ["tor browser", ["", "Tor"]],
            ["microsoft-edge", ["󰇩", "Edge"]],
            ["brave", ["", "Brave"]],
            ["zen", ["", "Zen"]],
            ["discord", ["", "Discord"]],
            ["vesktop", ["", "Vesktop"]],
            ["equibop", ["", "Equibop"]],
            ["telegram", ["", "Telegram"]],
            ["whatsapp|wasistlos", ["󰖣", "WhatsApp"]],
            ["pavucontrol", ["󰽰", "Pavucontrol"]],
            ["clocks", ["󰔛", "Clocks"]],
            ["org\.kde\.dolphin", ["", "Dolphin"]],
            ["org\.gnome\.nautilus", ["", "Nautilus"]],
            ["org\.gnome\.loupe", ["", "Loupe"]],
            ["steam", ["", "Steam"]],
            ["org\.prismlauncher\.prismlauncher", ["󰍳", "Prism"]],
            ["minecraft", ["󰍳", "Minecraft"]],
            ["io\.github\.qalculate\.qalculate-qt", ["󰪚", "Qalculate!"]],
            ["spotify", ["󰓇", "Spotify"]],
            ["com\.stremio\.stremio", ["󱖑", "Stremio"]],
            ["mpv", ["", "mpv"]],
            ["ark", ["", "Ark"]],
            ["gimp", ["", "GIMP"]],
            ["obsidian", ["󱞁", "Obsidian"]],
            ["com\.obsproject\.studio", ["", "OBS Studio"]],
            ["libreoffice-writer", ["󱎒", "LibreOffice Writer"]],
            ["libreoffice-calc", ["󱎏", "LibreOffice Calc"]],
            ["libreoffice-impress", ["󱎐", "LibreOffice Impress"]],
            ["libreoffice-draw", ["", "LibreOffice Draw"]],
            ["libreoffice-base", ["", "LibreOffice Base"]],
            ["jetbrains-idea-ce", ["", "IntelliJ IDEA"]],
            ["jetbrains-studio", ["󰀴", "Android Studio"]],
            ["github desktop", ["", "GitHub Desktop"]],
            ["blueman", ["󰂯", "Blueman"]],
            ["copyq", ["", "CopyQ"]],
            ["nwg", ["󰨇", "Display Settings"]],
            ["^$", ["󰇄", "Desktop"]],
            [
                "(.+)",
                [
                    "󰣆",
                    formatClass ? formatTitle(clazz) : title,
                ],
            ],
        ];

        const foundMatch = windowTitleMap.find((wt) =>
            RegExp(wt[0]).test(clazz.toLowerCase())
        );

        return foundMatch ? foundMatch[1] : ["󰣆", formatClass ? formatTitle(clazz) : title];
    }

    function formatTitle(title) {
        const partsByDot = title.split(".");
        const latestPart = partsByDot[partsByDot.length - 1];

        const partsByDash = latestPart.split("-");
        const firstPart = partsByDash[0];

        return firstPart.charAt(0).toUpperCase() + firstPart.slice(1);
    }

    function getVolumeIcon(volume, muted) {
        if (muted) return "󰝟";
        return [
                  [101, "󱄡"],
                  [67, "󰕾"],
                  [34, "󰖀"],
                  [1, "󰕿"],
                  [0, "󰸈"],
                ].find(
                  ([threshold]) => parseInt(threshold.toString()) <= volume
                )?.[1];
    }
}
