import { bind } from "astal";
import Network from "gi://AstalNetwork";

export default function WiFiControls() {
  const { wifi } = Network.get_default();

  return (
    <box className="WifiControls bar_element">
      <icon
        tooltipText={bind(wifi, "ssid").as(String)}
        icon={bind(wifi, "iconName")}
      />
    </box>
  );
}
