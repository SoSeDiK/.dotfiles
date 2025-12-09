import { Variable, bind } from "astal";
import { App, Astal, Gdk } from "astal/gtk3";
import Network from "gi://AstalNetwork";

export const wifiOptionsVisible = Variable(false);

export const WifiOptionsMenu = (monitor: Gdk.Monitor) => {
  const { wifi } = Network.get_default();

  return (
    <window
      className="WifiOptions menu"
      visible={bind(wifiOptionsVisible)}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      setup={(self) => App.add_window(self)}
    >
      <box className="menu_window_box" vertical>
        <box vertical className="menu_box">
          <button
            cursor="pointer"
            onClicked={() => {
              if (wifi.scanning) return;
              wifi.scan();
            }}
          >
            {bind(wifi, "scanning").as((scanning) => (scanning ? "󰌪" : "󰌩"))}
          </button>
          {bind(wifi, "access_points").as((aps) =>
            aps.map((ap) => (
              <box>
                <icon icon={bind(ap, "iconName")} />
                <label
                  label={bind(ap, "ssid").as((ssid) => ssid || ap.bssid)}
                />
              </box>
            ))
          )}
        </box>
      </box>
    </window>
  );
};

export default function WiFiControls() {
  const { wifi } = Network.get_default();

  return (
    <box className="WifiControls bar_element">
      <button
        cursor="pointer"
        onClicked={() => wifiOptionsVisible.set(!wifiOptionsVisible.get())}
      >
        <icon
          tooltipText={bind(wifi, "ssid").as(String)}
          icon={bind(wifi, "iconName")}
        />
      </button>
    </box>
  );
}
