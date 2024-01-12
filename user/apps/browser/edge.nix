{ config, pkgs, username, ... }:

{
  # Yeah... I'm sorry!
  home.packages = with pkgs; [
    microsoft-edge
  ];
}
