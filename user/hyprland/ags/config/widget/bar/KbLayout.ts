const hyprland = await Service.import("hyprland");

const KbLayout = () =>
  Widget.Button({
    class_names: ["kb_layout", "simple_box"],
    child: Widget.Label({
      label: "en",
      setup: (self) => {
        self.hook(
          hyprland,
          (w, kbdName, layoutName) => {
            if (!layoutName) return;

            if (layoutName === "Russian-Ukrainian (United)") {
              w.label = "ua";
            } else if (layoutName === "English (US)") {
              w.label = "en";
            } else {
              w.label = "lang";
            }
            self.tooltip_text = layoutName;
          },
          "keyboard-layout"
        );
      },
    }),
  });

export default () => KbLayout();
