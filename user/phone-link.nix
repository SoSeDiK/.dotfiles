{ pkgs, ... }:

{
  home.packages = with pkgs; [
    scrcpy # View/Control phone screen (also broadcasts audio!)
  ];
}
