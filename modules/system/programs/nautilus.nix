{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  programs.nautilus-open-any-terminal = lib.mkIf (pkgs ? kitty) {
    enable = true;
    terminal = "kitty";
  };

  # Quick file preview (pressing Space)
  services.gnome.sushi.enable = true;
}
