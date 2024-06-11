{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    heroic # Epic Games launcher
  ];

  # Gaming
  programs.gamemode.enable = true;
}
