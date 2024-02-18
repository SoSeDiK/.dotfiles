{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./kitty.nix
    ./shell-aliases.nix
    ./starship.nix
    ./zsh.nix
  ];
}
