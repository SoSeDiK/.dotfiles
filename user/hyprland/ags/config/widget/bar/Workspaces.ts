const hyprland = await Service.import("hyprland");

const dispatch = (ws: string | number) =>
  hyprland.messageAsync(`dispatch workspace ${ws}`);

const dispatchOverview = () =>
  hyprland.messageAsync(`dispatch hyprexpo:expo toggle`);

function getSpecial(monitor: number): string | null {
  const special = Utils.exec(
    'bash -c "hyprctl monitors -j | jq ".[' +
      monitor +
      '].specialWorkspace.name""'
  );
  return special === '""' ? null : special.substring(9, special.length - 1);
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

export const Workspaces = (monitor: number) =>
  Widget.Button({
    class_names: ["workspaces", "simple_box"],
    onClicked: () => dispatchOverview(),
    onScrollUp: () => dispatch("m+1"),
    onScrollDown: () => dispatch("m-1"),
    child: Widget.Box({
      spacing: 8,
      children: [
        Widget.Box({
          spacing: 6,
          children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
            Widget.Label({
              class_name: "workspace",
              attribute: i,
              vpack: "center",
              label: `${i}`,
              setup: (self) =>
                self.hook(hyprland, () => {
                  self.toggleClassName(
                    "active",
                    hyprland.active.workspace.id === i
                  );
                  self.toggleClassName(
                    "occupied",
                    (hyprland.getWorkspace(i)?.windows || 0) > 0
                  );
                }),
            })
          ),
        }),
        Widget.Label({
          class_name: "special",
          setup: (self) =>
            self.hook(hyprland, () => {
              const special = getSpecial(monitor);
              if (!special) {
                self.visible = false;
                return;
              }
              self.visible = true;
              self.label = getSpecialLabel(special);
            }),
        }),
      ],
    }),
  });
