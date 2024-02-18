{ config, pkgs, ... }:

{
  # Starship Prompt
  programs.starship = {
    enable = true;
    package = pkgs.starship;
  };

  home.file.".config/starship.toml".source = ./files/starship.toml;
}
