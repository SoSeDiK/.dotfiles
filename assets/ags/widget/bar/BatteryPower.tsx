import { Variable, bind, execAsync } from "astal";
import { App, Astal, Gdk, Gtk } from "astal/gtk3";
import Battery from "gi://AstalBattery";
import PowerProfiles from "gi://AstalPowerProfiles";
import Brightness from "../../service/brightness";

const BATTERY_ICONS: Record<string | number, string | Record<number, string>> =
  {
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
  const array = !charging ? BATTERY_ICONS : BATTERY_ICONS.charging;
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
      (charging ? BATTERY_ICONS.charging[101] : BATTERY_ICONS[100]) + " 100%"
    );

  if (level < 1) level = 1;

  return getClosestBatteryLevel(level, charging) + " " + level + "%";
}

export const batteryOptionsVisible = Variable(false);

type PowerProfileType =
  | "power-saver"
  | "balanced"
  | "performance"
  | "balanced-performance";

export const BatteryOptionsMenu = (monitor: Gdk.Monitor) => {
  const brightness = Brightness.get_default();
  const powerprofiles = PowerProfiles.get_default();

  const PowerProfile = (
    type: PowerProfileType,
    icon: string,
    name: string,
    onClick: () => void
  ) => (
    <box className="PowerProfile">
      <button
        cursor="pointer"
        className={bind(powerprofiles, "activeProfile").as((v) =>
          v === type ? "active" : ""
        )}
        onClicked={() => {
          powerprofiles.activeProfile = type;
          onClick();
        }}
      >
        <box>
          <label className="PowerProfileIcon" label={icon} />
          <label className="PowerProfileText" label={name} />
        </box>
      </button>
    </box>
  );

  return (
    <window
      className="BatteryOptions menu"
      visible={bind(batteryOptionsVisible)}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      setup={(self) => App.add_window(self)}
    >
      <box className="menu_window_box" vertical>
        <box className="Backlight menu_box">
          <button
            className="KbBacklight"
            cursor="pointer"
            valign={Gtk.Align.CENTER}
            onClicked={() => (brightness.kbd = brightness.kbd == 1 ? 0 : 1)}
          >
            {bind(brightness, "kbd").as((v) => (v == 1 ? "󰌌" : "󰥻"))}
          </button>
          <label
            label={bind(brightness, "screen").as((v) => {
              if (v < 0.1) return "󰃞";
              if (v < 0.5) return "󰃟";
              return "󰃠";
            })}
          />
          <slider
            className="simple_slider"
            cursor="pointer"
            value={bind(brightness, "screen")}
            onDragged={({ value }) => (brightness.screen = value)}
          />
          <label
            label={bind(brightness, "screen").as((v) => {
              let p = Math.floor(v * 100) + "%";
              while (p.length < 4) p = " " + p;
              return p;
            })}
          />
        </box>
        <box vertical className="PowerProfiles menu_box">
          {PowerProfile("power-saver", "󰾆", "Quiet", () =>
            execAsync(
              "hyprctl dispatch exec ~/.dotfiles/assets/hypr/scripts/gamemode.sh"
            )
          )}
          {PowerProfile("balanced", "󰾅", "Balanced", () =>
            execAsync("hyprctl reload")
          )}
          {PowerProfile("performance", "󰓅", "Performance", () =>
            execAsync("hyprctl reload")
          )}
        </box>
      </box>
    </window>
  );
};

export default function BatteryPower() {
  const battery = Battery.get_default();

  const timeRemaining = Variable.derive([
    bind(battery, "time_to_full"),
    bind(battery, "time_to_empty"),
  ]);

  const batteryChanges = Variable.derive([
    timeRemaining,
    bind(battery, "percentage"),
    bind(battery, "charging"),
  ]);

  const formatSeconds = (s: number) =>
    new Date(s * 1000).toISOString().slice(11, 19);

  return (
    <box className="Battery bar_element" visible={bind(battery, "isPresent")}>
      <button
        cursor="pointer"
        onClicked={() =>
          batteryOptionsVisible.set(!batteryOptionsVisible.get())
        }
        tooltipText={bind(timeRemaining).as(([full, empty]) => {
          if (full > 0) `Estimated charging time: ${formatSeconds(full)}`;
          if (empty > 0) `Estimated time left: ${formatSeconds(empty)}`;
          return "";
        })}
      >
        <label
          label={bind(batteryChanges).as(() =>
            formatBattery(
              Math.floor(battery.percentage * 100),
              battery.charging ||
                (battery.percentage > 0.95 && battery.time_to_full == 0),
              battery.percentage == 1
            )
          )}
        />
      </button>
    </box>
  );
}
