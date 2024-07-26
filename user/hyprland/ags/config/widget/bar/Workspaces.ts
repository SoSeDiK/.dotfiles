const hyprland = await Service.import("hyprland");

const dispatch = (ws: string | number) =>
  hyprland.messageAsync(`dispatch workspace ${ws}`);

const dispatchOverview = () =>
  hyprland.messageAsync(`dispatch hyprexpo:expo toggle`);

const Workspaces = () =>
  Widget.Button({
    class_names: ["workspaces", "simple_box"],
    onClicked: () => dispatchOverview(),
    onScrollUp: () => dispatch("m+1"),
    onScrollDown: () => dispatch("m-1"),
    child: Widget.Box({
      class_name: "box",
      spacing: 8,
      children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        Widget.Label({
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
  });

export default () => Workspaces();
