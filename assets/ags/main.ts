import { forMonitors } from "lib/utils";
import ActiveApp from "widget/bar/ActiveApp";
import { MediaWidget, AudioWidget, AudioMenu } from "widget/bar/Audio";
import BatteryLabel, { BatteryMenu } from "widget/bar/Battery";
import KbLayout from "widget/bar/KbLayout";
import Power, { PowerMenu } from "widget/bar/Power";
import SysTray from "widget/bar/SysTray";
import Time from "widget/bar/Time";
import { Workspaces } from "widget/bar/Workspaces";
import Notifications, { NotificationPopups } from "widget/Notifications";

function Left(monitor: number) {
  return Widget.Box({
    css: "padding: 0 5px;",
    spacing: 8,
    children: [Workspaces(monitor), ActiveApp()],
  });
}

function Center() {
  return Widget.Box({
    css: "padding: 0 5px;",
    spacing: 8,
    children: [KbLayout(), Time(), MediaWidget()],
  });
}

function Right() {
  return Widget.Box({
    css: "padding: 0 5px;",
    hpack: "end",
    spacing: 8,
    children: [
      SysTray(),
      AudioWidget(),
      BatteryLabel(),
      Notifications(),
      Power(),
    ],
  });
}

const Bar = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    class_name: "bar",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitor),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

function resetCss() {
  // main scss file
  const scss = `${App.configDir}/style/style.scss`;

  // target css file
  const css = `/tmp/ags-style.css`;

  // compile, reset, apply
  Utils.exec(`sass ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
}

resetCss();
Utils.monitorFile(`${App.configDir}/style`, resetCss);

App.config({
  windows: () => [
    ...forMonitors(Bar),
    // More!
    NotificationPopups(0),
    AudioMenu(),
    BatteryMenu(),
    PowerMenu(),
  ],
});
