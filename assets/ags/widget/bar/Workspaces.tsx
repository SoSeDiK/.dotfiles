import { Variable, Process, bind } from "astal";
import { Gdk, Gtk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";

function getSpecial(monitor: number): string | null {
  const special = Process.exec(
    'bash -c "hyprctl monitors -j | jq ".[' +
      monitor +
      '].specialWorkspace.name""'
  );
  return special === '""' ? null : special.substring(9, special.length - 1);
}

function getActiveId(monitor: number): number | null {
  const active = Process.exec(
    'bash -c "hyprctl monitors -j | jq ".[' + monitor + '].activeWorkspace.id""'
  );
  return active === '""' ? null : parseInt(active);
}

function getSpecialLabel(workspace: string) {
  switch (workspace) {
    case "private":
      return "󰗹";
    case "discord":
      return "󰙯";
    case "telegram":
      return "";
    case "temp":
      return "";
    case "music":
      return "󰎇";
    case "calculator":
      return "";
    default:
      return workspace;
  }
}

/**
 * Finds the Hyprland.Monitor that matches the Gdk.Monitor
 *
 * @param gdkmonitor the Gdk.Monitor to search for
 * @returns the matching Hyprland.Monitor, or null if not found
 */
function getHyprMonitor(gdkmonitor: Gdk.Monitor): Hyprland.Monitor | null {
  const display = Gdk.Display.get_default();
  if (display === null) return null;

  const monitor: Hyprland.Monitor | undefined = Hyprland.get_default()
    .get_monitors()
    .find((monitor) => display.get_monitor(monitor.id) === gdkmonitor);
  return monitor || null;
}

export default function Workspaces({
  gdkmonitor,
}: {
  gdkmonitor: Gdk.Monitor;
}) {
  const monitor: Hyprland.Monitor | null = getHyprMonitor(gdkmonitor);
  if (monitor === null)
    throw new Error(`Couldn't find matching monitor: ${gdkmonitor.model}`);

  const hypr = Hyprland.get_default();

  const activeWs = Variable<number | null>(getActiveId(monitor.id));
  const specialWs = Variable<string | null>(getSpecial(monitor.id));

  const wsData = Variable.derive([
    bind(hypr, "workspaces"),
    bind(hypr, "focusedWorkspace"),
    activeWs,
  ]);

  return (
    <box
      className="Workspaces bar_element"
      setup={(self) =>
        self.hook(hypr, "event", (_h, event: string, args: string) => {
          if (event === "activespecial") {
            const data = args.split(",");
            const mon = data[1];
            if (mon !== monitor.name) return;

            const ws = data[0];
            specialWs.set(ws === "" ? null : ws.slice(8)); // Remove "special:" prefix
          } else if (event === "workspacev2") {
            const data = args.split(",");
            const wsId = parseInt(data[0]);
            const monLowerLimit = monitor.id * 10;
            if (wsId < monLowerLimit) return;
            if (wsId > monLowerLimit + 10) return;

            activeWs.set(wsId);
          }
        })
      }
    >
      <eventbox
        onScroll={(_, e) => {
          const sWs = specialWs.get();
          if (sWs !== null) hypr.dispatch("togglespecialworkspace", sWs);
          hypr.dispatch("workspace", e.delta_y < 0 ? "m+1" : "m-1");
        }}
      >
        <box className="Workspace">
          {Array.from({ length: 10 }, (_, i) => i + 1).map((i) => {
            var workspaceId = monitor.id * 10 + i;
            return (
              <button
                valign={Gtk.Align.CENTER}
                cursor="pointer"
                className={bind(wsData).as(([_, fWs, aWs]) => {
                  let classes: string[] = [];
                  if (hypr.get_workspace(workspaceId) != null)
                    classes.push("active");
                  if (workspaceId === fWs.id) classes.push("focused");
                  if (workspaceId === aWs) classes.push("displayed");
                  return classes.join(" ");
                })}
                onClicked={() =>
                  hypr.message_async(
                    "dispatch workspace " + workspaceId,
                    () => {}
                  )
                }
              >
                {<box className="Filler" />}
              </button>
            );
          })}
        </box>
      </eventbox>
      <box className="Special" visible={bind(specialWs).as((ws) => ws != null)}>
        <button
          cursor="pointer"
          valign={Gtk.Align.CENTER}
          onClicked={() => {
            const sWs = specialWs.get();
            if (sWs !== null) hypr.dispatch("togglespecialworkspace", sWs);
          }}
        >
          <box className="Filler">
            <label
              label={bind(specialWs).as(
                (ws) => (ws && getSpecialLabel(ws)) || ""
              )}
            />
          </box>
        </button>
      </box>
    </box>
  );
}
