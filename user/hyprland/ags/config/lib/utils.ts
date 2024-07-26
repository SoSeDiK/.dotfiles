import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk?version=3.0";

export function forMonitors(widget: (monitor: number) => Gtk.Window) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(n, 0).flatMap(widget);
}

/**
 * @returns [start...length]
 */
export function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}

export const closeAllMenus = (excluded: string) => {
  const menuWindows = App.windows
    .filter((w) => {
      return w.name != excluded;
    })
    .filter((w) => {
      if (w.name) {
        return /.*Menu/.test(w.name);
      }

      return false;
    })
    .map((w) => w.name);

  menuWindows.forEach((w) => {
    if (w) {
      App.closeWindow(w);
    }
  });
};

export const openMenu = (window: string) => {
  closeAllMenus(window);
  App.toggleWindow(window);
};
