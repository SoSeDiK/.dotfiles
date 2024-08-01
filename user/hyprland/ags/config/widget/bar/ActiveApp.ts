import { ActiveClient } from "types/service/hyprland";

const hyprland = await Service.import("hyprland");

const EDIT_MODE = true;

function formatTitle(title: string): string {
  const partsByDot = title.split(".");
  const latestPart = partsByDot[partsByDot.length - 1];

  const partsByDash = latestPart.split("-");
  const firstPart = partsByDash[0];

  return firstPart.charAt(0).toUpperCase() + firstPart.slice(1);
}

const filterTitle = (windowtitle: ActiveClient) => {
  const windowTitleMap = [
    ["kitty", "󰄛   Kitty"],
    ["codium-url-handler", "   VSCodium"],
    ["firefox", "󰈹   Firefox"],
    ["firefox-nightly", "󰈹   Firefox"],
    ["firefox-nightly-private", "󰈹   Firefox"],
    ["tor browser", "   Tor"],
    ["microsoft-edge", "󰇩   Edge"],
    ["discord", "    Discord"],
    ["vesktop", "    Vesktop"],
    ["telegram", "    Telegram"],
    ["whatsapp", "󰖣    WhatsApp"],
    ["org.kde.dolphin", "   Dolphin"],
    ["org.gnome.nautilus", "   Nautilus"],
    ["steam", "   Steam"],
    ["org.prismlauncher.prismlauncher", "󰍳   Prism"],
    ["io.github.qalculate.qalculate-qt", "󰪚   Qalculate!"],
    ["spotify", "󰓇   Spotify"],
    ["com.stremio.stremio", "󱖑   Stremio"],
    ["mpv", "   mpv"],
    ["gimp-2.10", "   GIMP"],
    ["jetbrains-idea-ce", "   IntelliJ IDEA"],
    ["jetbrains-studio", "󰀴   Android Studio"],
    ["github desktop", "   GitHub Desktop"],
    ["^$", "󰇄   Desktop"],
    [
      "(.+)",
      `󰣆   ${EDIT_MODE ? windowtitle.class : formatTitle(windowtitle.class)}`,
    ],
  ];

  const foundMatch = windowTitleMap.find((wt) =>
    RegExp(wt[0]).test(windowtitle.class.toLowerCase())
  );

  return foundMatch ? foundMatch[1] : windowtitle.class;
};

const ActiveApp = () =>
  Widget.Box({
    child: Widget.Button({
      class_names: ["kb_layout", "simple_box"],
      child: Widget.Label({
        class_name: "active_app",
        label: hyprland.active.bind("client").as((v) => filterTitle(v)),
      }),
    }),
  });

export default () => ActiveApp();
