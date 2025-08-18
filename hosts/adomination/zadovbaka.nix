{ self, ... }:

{
  imports = [
    ./home-manager/vscode.nix

    # Gaming
    "${self}/modules/home-manager/gaming/mangohud.nix"

    # Shell
    "${self}/modules/home-manager/shell/shell-aliases.nix"
    "${self}/modules/home-manager/shell/starship.nix"
    "${self}/modules/home-manager/shell/zsh.nix"
  ];

  programs.kitty.enable = true;

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05"; # tldr: Do not change :)
}
