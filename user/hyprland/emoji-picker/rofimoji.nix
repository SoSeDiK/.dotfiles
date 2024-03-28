{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofimoji
  ];

  home.file.".local/share/rofimoji/data/emojis_smileys_emotion.additional.csv".source = ./extras/emojis_smileys_emotion.additional.csv;
}
