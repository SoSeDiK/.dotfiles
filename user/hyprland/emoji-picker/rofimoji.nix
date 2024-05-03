{ config, pkgs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) homeDir flakeDir;
in
{
  home.packages = with pkgs; [
    rofimoji
  ];

  home.file.".local/share/rofimoji/data/emojis_smileys_emotion.additional.csv".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/hyprland/emoji-picker/extras/emojis_smileys_emotion.additional.csv";
}
