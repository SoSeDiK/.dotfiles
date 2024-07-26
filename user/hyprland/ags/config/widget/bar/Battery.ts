import PopupWindow from "widget/misc/PopupWindow";
import brightness from "service/brightness";
import powerprofiles, { PowerProfileType } from "service/powerprofiles";
import { openMenu } from "lib/utils";

const battery = await Service.import("battery");

const BATTERY_MENU = "BatteryMenu";

const battery_icons = {
  charging: {
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
  },
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

function getClosestBatteryLevel(level: number, charging: boolean = false) {
  const array = !charging ? battery_icons : battery_icons.charging;
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

function formatBattery(
  level: number,
  charging: boolean = false,
  charged: boolean = false
) {
  if (charged)
    return (
      (charging ? battery_icons.charging[101] : battery_icons[100]) + " 100%"
    );

  if (level < 1) level = 1;

  return getClosestBatteryLevel(level, charging) + " " + level + "%";
}

function BatteryLabel() {
  const formatSeconds = (s: number) =>
    new Date(s * 1000).toISOString().substr(11, 8); // TODO proper format

  return Widget.Button({
    class_names: ["battery", "simple_box"],
    visible: false,
    onPrimaryClick: () => openMenu(BATTERY_MENU),
    child: Widget.Label({
      label: formatBattery(
        battery.percent,
        battery.charging ||
          (battery.percent > 95 && battery.time_remaining == 0),
        battery.charged
      ),
    }),
    tooltip_text: battery.bind("time_remaining").as((v) => {
      if (v == 0) return "";
      return `Estimated time left: ${formatSeconds(battery.time_remaining)}`;
    }),
    setup: (self) => {
      self.hook(battery, () => {
        self.child.label = formatBattery(
          battery.percent,
          battery.charging ||
            (battery.percent > 95 && battery.time_remaining == 0),
          battery.charged
        );
        self.visible = battery.available;
      });
    },
  });
}

export function BatteryMenu() {
  const brightnessSlider = Widget.Slider({
    draw_value: false,
    hexpand: true,
    value: brightness.bind("screen"),
    onChange: ({ value }) => (brightness.screen = value),
  });

  const brightnessView = Widget.Box({
    class_name: "brightness",
    spacing: 8,
    children: [
      Widget.Button({
        css: "padding: 0 8px;",
        vpack: "center",
        child: Widget.Label({ label: "󰃠" }),
        onClicked: () => (brightness.screen = 0),
        tooltip_text: brightness
          .bind("screen")
          .as((v) => `Screen Brightness: ${Math.floor(v * 100)}%`),
      }),
      brightnessSlider,
      Widget.Label({
        label: brightness.bind("screen").as((v) => {
          const br = Math.floor(v * 100);
          return br + "%";
        }),
      }),
    ],
  });

  const PowerProfile = (
    type: PowerProfileType,
    icon: string,
    name: string,
    onClick: () => void
  ) =>
    Widget.Button({
      class_names: ["profile", "no_initial_bg"],
      css: "padding: 0 8px;",
      child: Widget.Box({
        spacing: 8,
        children: [
          Widget.Label({ label: icon }),
          Widget.Label({ label: name }),
        ],
      }),
      onClicked: () => {
        powerprofiles.profile = type;
        onClick();
      },
      setup: (self) => {
        self.hook(powerprofiles, (w) => {
          w.toggleClassName("active", powerprofiles.profile === type);
        });
      },
    });

  const powerProfilesView = Widget.Box({
    vertical: true,
    visible: powerprofiles.available,
    spacing: 8,
    children: [
      Widget.Label({ label: "Power Profiles" }),
      Widget.Box({
        vertical: true,
        children: [
          PowerProfile("power-saver", "󰾆", "Quiet", () =>
            Utils.execAsync(
              "hyprctl dispatch exec ~/.dotfiles/user/hyprland/hypr/scripts/gamemode.sh"
            )
          ),
          PowerProfile("balanced", "󰾅", "Balanced", () =>
            Utils.execAsync("hyprctl reload")
          ),
          PowerProfile("performance", "󰓅", "Performance", () =>
            Utils.execAsync("hyprctl reload")
          ),
        ],
      }),
    ],
  });

  const popup = Widget.Box({
    css: "min-width: 320px; background-color: #131313; padding: 16px; border-radius: 10px;",
    child: Widget.Box({
      vertical: true,
      spacing: 8,
      children: [brightnessView, powerProfilesView],
    }),
  });

  return PopupWindow({
    name: BATTERY_MENU,

    class_name: "battery_menu",
    visible: false,
    keymode: "exclusive",
    child: popup,
    anchor: ["top", "right"],
  });
}

export default () => BatteryLabel();
