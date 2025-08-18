{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  programs.nautilus-open-any-terminal = lib.mkIf (pkgs ? kitty) {
    enable = true;
    terminal = "kitty";
  };

  # Quick file preview
  services.gnome.sushi.enable = true;
}
