import { App, Gdk, Gtk } from "astal/gtk3";
import style from "./style/style.scss";
import Bar from "./widget/Bar";
import { AudioOptionsMenu } from "./widget/bar/AudioWidget";
import { BatteryOptionsMenu } from "./widget/bar/BatteryPower";
import { PowerOptionsMenu } from "./widget/bar/PowerMenu";
import { WifiOptionsMenu } from "./widget/bar/WiFiControls";

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
        WifiOptionsMenu(monitor),
      ]);
    };

    App.get_monitors().map(setupBar);

    display?.connect("monitor-added", (_, monitor) => setupBar(monitor));

    display?.connect("monitor-removed", (_, monitor) => {
      bars.get(monitor)?.forEach((w) => w.destroy());
      bars.delete(monitor);
    });
  },
});
