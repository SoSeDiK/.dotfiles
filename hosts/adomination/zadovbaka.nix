{ self, pkgs, ... }:

{
  imports = [
    # Gaming
    "${self}/modules/home-manager/gaming/mangohud.nix"

    # Shell
    "${self}/modules/home-manager/shell/shell-aliases.nix"
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];

  home.stateVersion = "25.05";
}
