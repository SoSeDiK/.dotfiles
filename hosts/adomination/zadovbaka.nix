{ self, ... }:

{
  imports = [
    ./home-manager/firefox
    ./home-manager/vscode

    # Apps
    "${self}/modules/home-manager/apps/spicetify.nix"

    # Gaming
    "${self}/modules/home-manager/gaming/mangohud.nix"

    # Shell
    "${self}/modules/home-manager/shell/shell-aliases.nix"
    "${self}/modules/home-manager/shell/starship.nix"
    "${self}/modules/home-manager/shell/zsh.nix"

    # Theming
    "${self}/modules/home-manager/theming/gtk-qt.nix"
    "${self}/modules/home-manager/theming/stylix.nix"
  ];

  programs.kitty.enable = true;

  # Create XDG Dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05"; # tldr: Do not change :)
}
