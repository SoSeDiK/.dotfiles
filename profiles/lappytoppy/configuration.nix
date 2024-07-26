{ pkgs, nixos-hardware, profileName, ... }:

let
  inherit (import ./options.nix)
    name username hostname
    sysTimezone sysLocale sysExtraLocale;
in
{
  imports = [
    # Hardware
    ./hardware.nix # Include the results of the hardware scan.
    nixos-hardware.nixosModules.lenovo-legion-15arh05h

    # Secrets!
    ./sops-system.nix

    # Hardware-specific modules
    ../../system/hardware/battery.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/brightness.nix
    ../../system/hardware/vfio-amd-nvidia.nix

    # Universal defaults
    ../../system

    # WM
    ../../system/hyprland

    # Profile-specific thingies
    ../../system/lenovo-legion.nix

    # Misc profile-specific thingies
    (./. + "../../../system/profile/${profileName}.nix")

    ../../system/apps/virtualization/virtualization.nix # TODO
  ];

  # Enable networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Use Cloudflare's DNS servers
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Set your time zone
  time.timeZone = sysTimezone;

  # Select internationalisation properties
  i18n.defaultLocale = sysLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = sysExtraLocale;
    LC_IDENTIFICATION = sysExtraLocale;
    LC_MEASUREMENT = sysExtraLocale;
    LC_MONETARY = sysExtraLocale;
    LC_NAME = sysExtraLocale;
    LC_NUMERIC = sysExtraLocale;
    LC_PAPER = sysExtraLocale;
    LC_TELEPHONE = sysExtraLocale;
    LC_TIME = sysExtraLocale;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    gc = {
      automatic = false; # Handled by nh
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
