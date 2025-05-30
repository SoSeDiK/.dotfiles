import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

const EDIT_MODE = false;

function formatTitle(title: string): string {
  const partsByDot = title.split(".");
  const latestPart = partsByDot[partsByDot.length - 1];

  const partsByDash = latestPart.split("-");
  const firstPart = partsByDash[0];

  return firstPart.charAt(0).toUpperCase() + firstPart.slice(1);
}

const filterTitle = (client: Hyprland.Client): [string, string] => {
  const windowTitleMap: [string, [string, string]][] = [
    ["kitty", ["󰄛", "Kitty"]],
    ["codium-url-handler", ["", "VSCodium"]],
    ["firefox", ["󰈹", "Firefox"]],
    ["firefox-nightly", ["󰈹", "Firefox"]],
    ["firefox-nightly-private", ["󰈹", "Firefox"]],
    ["tor browser", ["", "Tor"]],
    ["microsoft-edge", ["󰇩", "Edge"]],
    ["brave", ["", "Brave"]],
    ["discord", ["", "Discord"]],
    ["vesktop", ["", "Vesktop"]],
    ["equibop", ["", "Equibop"]],
    ["telegram", ["", "Telegram"]],
    ["whatsapp", ["󰖣", "WhatsApp"]],
    ["org.kde.dolphin", ["", "Dolphin"]],
    ["org.gnome.nautilus", ["", "Nautilus"]],
    ["steam", ["", "Steam"]],
    ["org.prismlauncher.prismlauncher", ["󰍳", "Prism"]],
    ["io.github.qalculate.qalculate-qt", ["󰪚", "Qalculate!"]],
    ["spotify", ["󰓇", "Spotify"]],
    ["com.stremio.stremio", ["󱖑", "Stremio"]],
    ["mpv", ["", "mpv"]],
    ["gimp-2.10", ["", "GIMP"]],
    ["jetbrains-idea-ce", ["", "IntelliJ IDEA"]],
    ["jetbrains-studio", ["󰀴", "Android Studio"]],
    ["github desktop", ["", "GitHub Desktop"]],
    ["^$", ["󰇄", "Desktop"]],
    [
      "(.+)",
      [
        "󰣆",
        EDIT_MODE ? client.class : formatTitle(client.class), // Format class name if no specific match
      ],
    ],
  ];

  const foundMatch = windowTitleMap.find((wt) =>
    RegExp(wt[0]).test(client.class.toLowerCase())
  );

  return foundMatch ? foundMatch[1] : ["󰣆", client.class];
};

export default function ActiveApp() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  return (
    <box visible={focused.as(Boolean)}>
      {focused.as((client) => {
        if (!client) return null;

        const [icon, title] = filterTitle(client);
        return (
          <box className="FocusedApp bar_element">
            <label className="AppIcon" label={icon} />
            <label className="AppTitle" label={title} />
          </box>
        );
      })}
    </box>
  );
}
