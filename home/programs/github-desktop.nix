{ pkgs, ... }:

{
  # Apps
  home.packages = with pkgs; [
    github-desktop
    # Fixup inability to delete files from GUI
    glib
  ];

  # Handle auth within the app
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
  };
}
