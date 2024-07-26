import { TrayItem } from "types/service/systemtray";

const systemtray = await Service.import("systemtray");

const SysTrayItem = (item: TrayItem) =>
  Widget.Button({
    class_names: ["tray_item", "no_initial_bg"],
    child: Widget.Icon({ icon: item.bind("icon") }),
    tooltipMarkup: item.bind("tooltip_markup"),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

function SysTray() {
  return Widget.Button({
    class_names: ["systray", "simple_box"],
    child: Widget.Box({
      children: systemtray.bind("items").as((item) => item.map(SysTrayItem)),
    }),
  });
}

export default () => SysTray();
