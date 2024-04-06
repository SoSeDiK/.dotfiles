{ inputs, pkgs, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [
    spicetify-nix.homeManagerModule
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledCustomApps = with spicePkgs.apps; [
      new-releases
      lyrics-plus
    ];

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      fullAppDisplayMod
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      seekSong
      copyToClipboard
      hidePodcasts
      history
    ];
  };
}
