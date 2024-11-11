import { App, Gdk, Gtk } from "astal/gtk3";
import style from "./style/style.scss";
import Bar from "./widget/Bar";
import { AudioOptionsMenu } from "./widget/bar/AudioWidget";
import { BatteryOptionsMenu } from "./widget/bar/BatteryPower";
import { PowerOptionsMenu } from "./widget/bar/PowerMenu";

const bars = new Map<Gdk.Monitor, Gtk.Widget[]>();

App.start({
  css: style,
  main() {
    const display = Gdk.Display.get_default();

    const setupBar = (monitor: Gdk.Monitor) => {
      bars.set(monitor, [
        Bar(monitor),
        AudioOptionsMenu(monitor),
        BatteryOptionsMenu(monitor),
        PowerOptionsMenu(monitor),
      ]);
    };

    App.get_monitors().map(setupBar);

    display?.connect("monitor-added", (disp, monitor) => setupBar(monitor));

    display?.connect("monitor-removed", (disp, monitor) => {
      bars.get(monitor)?.forEach((w) => w.destroy());
      bars.delete(monitor);
    });
  },
});
