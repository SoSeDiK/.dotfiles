# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, wm, name, username, hostname, timezone, locale, timeLocale, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix # Include the results of the hardware scan.

    ../../system/hardware/battery.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/brightness.nix
    ../../system/hardware/lenovo.nix

    ../../system/shell/zsh.nix

    ../../system/apps/polkit/polkit.nix
    ../../system/apps/misc/devtools.nix
    ../../system/apps/misc/flatpak.nix
    ../../system/apps/misc/gnome-disks.nix
    ../../system/apps/virtualization/virtualization.nix

    (./. + "../../../system/wm/${wm}.nix")
  ];

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
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = name;
    extraGroups = [ "networkmanager" "wheel" "kvm" "games" ]; # TODO games group is needed for piper
    packages = with pkgs; [];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Boot animation
  boot.plymouth.enable = true;
  # Hide boot logs (untill playmouth can take over stage 1)
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = timeLocale;
    LC_IDENTIFICATION = timeLocale;
    LC_MEASUREMENT = timeLocale;
    LC_MONETARY = timeLocale;
    LC_NAME = timeLocale;
    LC_NUMERIC = timeLocale;
    LC_PAPER = timeLocale;
    LC_TELEPHONE = timeLocale;
    LC_TIME = timeLocale;
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

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
