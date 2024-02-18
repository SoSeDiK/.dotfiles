{ inputs, config, pkgs, nixos-hardware, profileName, wm, ... }:

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

    # Universal defaults
    ../../system/default.nix

    # Profile-specific thingies
    ../../system/steam.nix
    ../../system/lenovo-legion.nix
    # Misc profile-specific thingies
    (./. + "../../../system/profile/${profileName}.nix")


    ../../system/hardware/battery.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/brightness.nix

    ../../system/shell/zsh.nix

    ../../system/ahh.nix
    ../../system/apps/misc/devtools.nix
    ../../system/apps/misc/gnome-disks.nix
    ../../system/apps/virtualization/virtualization.nix

    (./. + "../../../system/wm/${wm}.nix")
  ];

  # Enable networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

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
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ###

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zenith-nvidia
    pciutils
    lsof
    toybox
    wget
    curl
    git
    zip
    unzip
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
