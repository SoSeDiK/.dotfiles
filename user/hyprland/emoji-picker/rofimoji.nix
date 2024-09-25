{ config, pkgs, self, ... }:

{
  home.packages = with pkgs; [
    rofimoji
  ];

  home.file.".local/share/rofimoji/data/emojis_smileys_emotion.additional.csv".source = config.lib.file.mkOutOfStoreSymlink "${self}/user/hyprland/emoji-picker/extras/emojis_smileys_emotion.additional.csv";
}
