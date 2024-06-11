{ ... }:

{
  imports = [
    ./fonts
    ./boot.nix
    ./cli-collection.nix
    ./dbus.nix
    ./display-manager.nix
    ./file-manager.nix
    ./flatpak.nix
    ./gaming.nix
    ./gnome-disks.nix
    ./keyring.nix
    ./nh.nix
    ./ntp.nix # Time sync
    ./openrazer.nix
    ./piper.nix
    ./pipewire.nix # Sound management
    ./polkit.nix
    ./printer.nix
    ./steam.nix
    ./stylix.nix
    ./bash.nix
    ./zsh.nix
  ];
}
