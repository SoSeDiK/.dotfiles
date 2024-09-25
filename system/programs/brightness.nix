{ pkgs, ... }:

{
  # Enable brightness control util
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
