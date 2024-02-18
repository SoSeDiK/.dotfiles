{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      arrterian.nix-env-selector
    ];
  };

  home.packages = with pkgs; [
    nixpkgs-fmt # nix formatter for codium
  ];
}
