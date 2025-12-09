{
  config,
  lib,
  pkgs,
  self',
  ...
}:

let
  emoji-font-name = "Noto Color Emoji";
  emoji-font = self'.packages.noto-emoji-plus;
in
{
  stylix = lib.mkIf config.stylix.enable {
    fonts = {
      emoji = {
        package = emoji-font;
        name = emoji-font-name;
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # Extra font rules
  fonts.fontconfig.defaultFonts = {
    monospace = [
      emoji-font-name
      "Symbols Nerd Font Mono"
    ];
    sansSerif = [
      emoji-font-name
      "Symbols Nerd Font Mono"
    ];
    serif = [
      emoji-font-name
      "Symbols Nerd Font Mono"
    ];
    emoji = [ "Symbols Nerd Font Mono" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      noto-fonts-color-emoji = emoji-font;
    })
  ];
}
