{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
    ];
  };

  # nix-ide extras
  home.packages = with pkgs; [
    nil # nix auto completion
    nixfmt-rfc-style # nix formatter
  ];
}
