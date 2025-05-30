{ pkgs, self, ... }:

let
  appleFonts = pkgs.callPackage "${self}/pkgs/fonts/apple-fonts.nix" { };
  notoFonts = pkgs.callPackage "${self}/pkgs/fonts/rkbdi-noto-sans" { };
in
{
  # Fonts are nice to have
  # List installed fonts: fc-list

  environment.systemPackages = with pkgs; [
    font-manager
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    fira-code
    nerd-fonts.fira-code
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    appleFonts # Mostly for use by Firefox theme
    notoFonts
  ];

  # Enable custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  fonts.fontDir.enable = true;

  fonts.fontconfig.useEmbeddedBitmaps = true;

  # Add custom keyboard layout (ruu)
  console.useXkbConfig = true;
  services.xserver = {
    xkb.extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [
        "rus"
        "ukr"
        "bel"
      ];
      symbolsFile = "${self}/assets/kb-layouts/ruu.xkb";
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(capslock)";
          };
          "capslock:C-S-M" = { };
        };
      };
    };
  };
}
