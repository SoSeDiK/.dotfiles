{ inputs, pkgs, ... }:

let
  aagl = inputs.aagl; # An Anime Game Launcher
in
{
  environment.systemPackages = with pkgs; [
    heroic # Epic Games launcher
  ];

  # Gaming
  programs.gamemode.enable = true;
}
