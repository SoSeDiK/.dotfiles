{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    settings = {
      background-opacity = pkgs.lib.mkForce "0.65";
      font_family = "FiraCode Nerd Font";
    };
  };
}
