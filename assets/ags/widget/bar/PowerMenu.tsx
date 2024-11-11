import { Variable, bind, exec } from "astal";
import { App, Astal, Gdk } from "astal/gtk3";

export const powerOptionsVisible = Variable(false);

interface PowerOptionData {
  icon: string;
  label: string;
  handler: () => void;
}

export const PowerOptionsMenu = (monitor: Gdk.Monitor) => {
  const PowerOption = ({ icon, label, handler }: PowerOptionData) => (
    <box className="PowerOption">
      <button cursor="pointer" onClicked={handler}>
        <box>
          <label className="PowerOptionIcon" label={icon} />
          <label className="PowerOptionLabel" label={label} />
        </box>
      </button>
    </box>
  );

  return (
    <window
      className="PowerOptions menu"
      visible={bind(powerOptionsVisible)}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      setup={(self) => App.add_window(self)}
    >
      <box className="menu_window_box" vertical>
        <PowerOption
          icon="󰒲"
          label="Suspend"
          handler={() => exec("systemctl suspend")}
        />
        <PowerOption
          icon="󰜉"
          label="Reboot"
          handler={() => exec("systemctl reboot")}
        />
        <PowerOption
          icon="󰍃"
          label="Logout"
          handler={() => exec("hyprctl dispatch exit")}
        />
        <PowerOption
          icon=""
          label="Shutdown"
          handler={() => exec("systemctl poweroff")}
        />
      </box>
    </window>
  );
};

export default function PowerMenu() {
  return (
    <box className="PowerMenu bar_element">
      <button
        cursor="pointer"
        onClicked={() => powerOptionsVisible.set(!powerOptionsVisible.get())}
      >
        {"⏻"}
      </button>
    </box>
  );
}
