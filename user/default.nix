{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./gtk-qt.nix
    ./kitty.nix
    ./shell-aliases.nix
    ./starship.nix
    ./swaylock.nix
    ./zsh.nix
  ];
}
