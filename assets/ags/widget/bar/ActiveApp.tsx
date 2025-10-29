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
    ["youtube_music", ["", "YT Music"]],
    ["com\.stremio\.stremio", ["󱖑", "Stremio"]],
    ["mpv", ["", "mpv"]],
    ["ark", ["", "Ark"]],
    ["xarchiver", ["", "Xarchiver"]],
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
