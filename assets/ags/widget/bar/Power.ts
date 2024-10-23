import { openMenu } from "lib/utils";
import PopupWindow from "widget/misc/PopupWindow";

const power_options = {
  sleep: "systemctl suspend",
  reboot: "systemctl reboot",
  logout: "hyprctl dispatch exit",
  shutdown: "shutdown now",
};

const POWER_WINDOW = "PowerMenu";

function Power() {
  return Widget.Button({
    class_names: ["power", "simple_box"],
    onPrimaryClick: () => openMenu(POWER_WINDOW),
    child: Widget.Label({ label: "⏻" }),
  });
}

function PowerOption(label: string, icon: string, command: () => void) {
  return Widget.Button({
    css: "padding: 0 8px;",
    class_names: ["power_option", "no_initial_bg"],
    onClicked: command,
    child: Widget.Label({ label: icon }),
    tooltip_text: label,
  });
}

export const PowerMenu = () => {
  const popup = Widget.Box({
    css: "background-color: #131313; padding: 16px; border-radius: 10px;",
    child: Widget.Box({
      children: [
        PowerOption("Shutdown", "", () =>
          Utils.execAsync(power_options.shutdown)
        ),
        PowerOption("Reboot", "󰜉", () => Utils.execAsync(power_options.reboot)),
        PowerOption("Sleep", "󰒲", () => {
          App.closeWindow(POWER_WINDOW);
          Utils.execAsync(power_options.sleep);
        }),
        PowerOption("Logout", "󰍃", () => Utils.execAsync(power_options.logout)),
      ],
    }),
  });

  return PopupWindow({
    name: POWER_WINDOW,

    class_name: "power_menu",
    visible: false,
    keymode: "exclusive",
    child: popup,
    anchor: ["top", "right"],
  });
};

export default () => Power();
