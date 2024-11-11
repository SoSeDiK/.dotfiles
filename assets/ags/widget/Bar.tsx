import { Astal, Gtk, Gdk } from "astal/gtk3";
import ActiveApp from "./bar/ActiveApp";
import AudioWidget from "./bar/AudioWidget";
import BatteryPower from "./bar/BatteryPower";
import KbLayout from "./bar/KbLayout";
import MediaWidget from "./bar/MediaWidget";
import PowerMenu from "./bar/PowerMenu";
import SysTray from "./bar/SysTray";
import TimeDate from "./bar/TimeDate";
import WiFiControls from "./bar/WiFiControls";
import Workspaces from "./bar/Workspaces";

export default function Bar(monitor: Gdk.Monitor) {
  const anchor =
    Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces gdkmonitor={monitor} />
          <ActiveApp />
        </box>
        <box>
          <KbLayout />
          <TimeDate />
          <MediaWidget />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <SysTray />
          <WiFiControls />
          <AudioWidget />
          <BatteryPower />
          <PowerMenu />
        </box>
      </centerbox>
    </window>
  );
}
