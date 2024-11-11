import { Process, Variable } from "astal";
import Hyprland from "gi://AstalHyprland";

function getLayoutName(keymap: string) {
  if (keymap === "English (US)") return "en";
  if (keymap === "Russian-Ukrainian (United)") return "ua";
  return "lang";
}

export default function KbLayout() {
  const hypr = Hyprland.get_default();

  const activeWorkspace = Variable<string>(
    getLayoutName(
      Process.exec(
        'bash -c "hyprctl devices -j | jq -r ".keyboards.[0].active_keymap""'
      ).trim()
    )
  );

  return (
    <box className="KbLayout bar_element">
      <button>
        <label
          label={activeWorkspace()}
          tooltipText="󰘴 Alt + 󰘶 Shift to change"
          setup={(self) =>
            self.hook(hypr, "event", (_h, event: string, args: string) => {
              if (event !== "activelayout") return;

              activeWorkspace.set(getLayoutName(args.split(",").pop() ?? ""));
            })
          }
        />
      </button>
    </box>
  );
}
