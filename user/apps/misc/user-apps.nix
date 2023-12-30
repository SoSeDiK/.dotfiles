{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    github-desktop
    qalculate-qt
    prismlauncher
    gnome.file-roller
    jetbrains.idea-community
    mission-center # Windows-like process manager
  ];
}
