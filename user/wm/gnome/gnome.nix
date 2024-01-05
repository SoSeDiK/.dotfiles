{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../apps/terminal/kitty.nix    # terminal
  ];

  home.packages = with pkgs; [
    # Libs
  ];
}
