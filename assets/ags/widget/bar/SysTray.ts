import { capitalize } from "lib/utils";
import { TrayItem } from "types/service/systemtray";

const hyprland = await Service.import("hyprland");
const systemtray = await Service.import("systemtray");

const dispatchSpecialWorkspace = (ws: string | number) =>
  hyprland.messageAsync(`dispatch togglespecialworkspace ${ws}`);

function openWorkspaceIfNeeded(id: string) {
  if (id == "chrome_status_icon_1") dispatchSpecialWorkspace("discord");
  else if (id == "TelegramDesktop") dispatchSpecialWorkspace("telegram");
}

const SysTrayItem = (item: TrayItem) =>
  Widget.Button({
    class_names: ["tray_item", "no_initial_bg"],
    child: Widget.Icon({ icon: item.bind("icon") }),
    tooltipMarkup: item
      .bind("tooltip_markup")
      .as((v) => v || capitalize(item.title)),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
    onMiddleClick: (_, event) => openWorkspaceIfNeeded(item.id),
  });

function SysTray() {
  return Widget.Button({
    class_names: ["systray", "simple_box"],
    child: Widget.Box({
      children: systemtray
        .bind("items")
        .as((item) => item.filter((i) => i.id).map(SysTrayItem)),
    }),
  });
}

export default () => SysTray();
