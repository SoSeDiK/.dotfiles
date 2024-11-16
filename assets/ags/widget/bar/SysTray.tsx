import { App } from "astal/gtk3";
import { bind } from "astal";
import { Astal, Gdk } from "astal/gtk3";
import Tray from "gi://AstalTray";
import Hyprland from "gi://AstalHyprland";

const dispatchSpecialWorkspace = (ws: string) =>
  Hyprland.get_default().dispatch("togglespecialworkspace", ws);

function openWorkspaceIfNeeded(id: string) {
  if (id == "chrome_status_icon_1") dispatchSpecialWorkspace("discord");
  else if (id == "TelegramDesktop") dispatchSpecialWorkspace("telegram");
  else if (id == "spotify-client") dispatchSpecialWorkspace("music");
}

export default function SysTray() {
  const tray = Tray.get_default();

  return (
    <box className="SysTray bar_element">
      {bind(tray, "items").as((items) =>
        items
          .filter((item) => item.gicon !== null)
          .map((item) => {
            if (item.iconThemePath) App.add_icons(item.iconThemePath);

            const menu = item.create_menu();

            return (
              <button
                className="SysTrayItem"
                tooltipMarkup={bind(item, "tooltipMarkup").as(
                  (tp) => tp || item.id
                )}
                onDestroy={() => menu?.destroy()}
                onClickRelease={(self, event) => {
                  if (event.button == Astal.MouseButton.MIDDLE) {
                    openWorkspaceIfNeeded(item.id);
                    return;
                  }
                  menu?.popup_at_widget(
                    self,
                    Gdk.Gravity.SOUTH,
                    Gdk.Gravity.NORTH,
                    null
                  );
                }}
              >
                <icon gIcon={bind(item, "gicon")} />
              </button>
            );
          })
      )}
    </box>
  );
}
