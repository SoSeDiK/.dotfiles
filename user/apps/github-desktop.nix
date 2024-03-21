{ config, pkgs, ... }:

{
  # Apps
  home.packages = with pkgs; [
    github-desktop
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
  };
}
