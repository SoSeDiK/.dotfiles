{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    grim slurp hyprpicker jq # dependencies
    grimblast
    satty
  ];
}
