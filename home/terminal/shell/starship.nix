{ config, dotAssetsDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  # Starship Prompt
  programs.starship.enable = true;

  xdg.configFile."starship.toml".source = mkOutOfStoreSymlink "${dotAssetsDir}/programs/starship.toml";
}
