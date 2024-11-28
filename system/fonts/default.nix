{ pkgs, self, ... }:

let
  appleFonts = pkgs.callPackage "${self}/pkgs/fonts/apple-fonts.nix" { };
  neofont = pkgs.callPackage "${self}/pkgs/fonts/neofont.nix" { inherit self; };
  notoFonts = pkgs.callPackage "${self}/pkgs/fonts/rkbdi-noto-sans.nix" { inherit self; };
in
{
  # Fonts are nice to have
  # List installed fonts: fc-list
  fonts.packages = with pkgs; [
    # Load only specified nerdfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Ubuntu" ]; })
    font-awesome
    appleFonts # Mostly for use by Firefox theme
    neofont
    notoFonts
  ];

  # Enable custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  fonts.fontDir.enable = true;

  # Add custom keyboard layout (ruu)
  console.useXkbConfig = true;
  services.xserver = {
    xkb.extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [ "rus" "ukr" "bel" ];
      symbolsFile = "${self}/assets/kb-layouts/ruu.xkb";
    };
  };
}
