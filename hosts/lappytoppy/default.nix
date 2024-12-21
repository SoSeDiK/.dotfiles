{ config, inputs, system, self, pkgs, hmUsers, ... }:

let
  username = "sosedik";

  sysTimezone = "Europe/Kyiv";
  sysLocale = "en_US.UTF-8"; # System locale
  sysExtraLocale = "uk_UA.UTF-8"; # Time/date/currency/etc. locale

  userSessionPassword = username: "users/${username}/session";
in
{
  # Setup users
  users.users.sosedik = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.${userSessionPassword "sosedik"}.path;
    description = "SoSeDiK";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  sops.secrets.${userSessionPassword "sosedik"}.neededForUsers = true;

  # Device components
  imports = [
    # Hardware
    ./hardware.nix # Include the results of the hardware scan
    ./hardware-modes.nix
    ./hw-brightness-proxy.nix # Fixup brightness control
    "${self}/system/hardware/battery.nix"
    "${self}/system/hardware/bluetooth.nix"
    "${self}/system/hardware/lenovo-legion.nix"

    inputs.nur.modules.nixos.default

    # Boot
    "${self}/system/boot"
    "${self}/system/boot/systemd-boot.nix"
    "${self}/system/boot/plymoth.nix"

    # Shell
    "${self}/system/shell/zsh.nix"

    # Security
    "${self}/system/security/keyring.nix"
    "${self}/system/security/polkit.nix"
    "${self}/system/security/sudo.nix"

    # Secrets
    "${self}/secrets/sops-system.nix"

    # Sound
    "${self}/system/sound/pipewire.nix"

    # WM
    "${self}/system/wm/hyprland.nix"

    # Services
    "${self}/system/services/dbus.nix"
    "${self}/system/services/tuigreet.nix"

    # Network
    "${self}/system/network/cloudflare.nix"

    # Fonts
    "${self}/system/fonts"

    # Programs
    "${self}/system/programs/peripherals/openrazer.nix"
    "${self}/system/programs/virtualization/podman.nix"
    "${self}/system/programs/virtualization/virt-manager.nix"
    "${self}/system/programs/brightness.nix"
    "${self}/system/programs/cli-collection.nix"
    "${self}/system/programs/gnome-disks.nix"
    "${self}/system/programs/handlr.nix"
    "${self}/system/programs/nautilus.nix" # File manager
    "${self}/system/programs/ydotool.nix"

    # Gaming
    "${self}/system/programs/steam.nix"

    # Dev
    "${self}/system/dev/jdk"

    # Theming
    "${self}/system/theming/stylix.nix"

    # Misc
    inputs.nix-index-database.nixosModules.nix-index

    # inputs.clipboard-sync.nixosModules.default # TODO breaks X11 clipboard :/
  ];

  # Apps
  environment.systemPackages = with pkgs; [
    tealdeer # tldr
    # Gaming
    heroic # Epic Games launcher
    # Misc
    qdirstat # Space management
    teamviewer
  ];

  programs.gamemode.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
    flake = "/home/${username}/.dotfiles";
  };

  # Use lix
  nix.package = pkgs.lix;

  # Allow running unpatched binaries
  programs.nix-ld.enable = true;

  # Run software via , (comma) without installing it
  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false;

  # Services
  services.fstrim.enable = true;

  # Auto start clipboard sync
  # services.clipboard-sync.enable = true; # TODO breaks X11 clipboard :/

  # For gaming
  # services.zerotierone.enable = true;

  services.tailscale.enable = true;
  services.tailscale.authKeyFile = config.sops.secrets.tailscaleAuthKey.path;

  # iPad as second screen
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = hmUsers;
  };

  # Shared network folder
  services.samba = {
    enable = true;
    nmbd.enable = false;
    winbindd.enable = false;
    openFirewall = true;
    settings = {
      global = {
        "map to guest" = "Bad User";
        "load printers" = "no";
        "log file" = "/var/log/samba/client.%I";
        "log level" = "2";
      };
      "lovely" = {
        "path" = "/home/${username}/Data/Share";
        "comment" = "Ah, lovely";
        "writable" = "yes";
        "public" = "yes";
        "guest only" = "yes";
        "force user" = "${username}";
        "force group" = "users";
        "create mask" = "777";
        "directory mask" = "777";
      };
    };
  };

  programs.openvpn3.enable = true;
  # services.openvpn.servers = {
  #   zaborona = {
  #     config = builtins.readFile (pkgs.fetchurl {
  #       url = "https://zaborona.help/openvpn-client-config/srv0.zaborona-help_maxroutes.ovpn";
  #       sha256 = "8b3f7d06bf7d55dfae4499b87dff3106517b648d74a5ae5ab977f4b5a164241c";
  #     });
  #     updateResolvConf = true;
  #     autoStart = false;
  #   };
  # };

  # Custom options (from modules)
  programs.openrazer = {
    enable = true;
    users = hmUsers;
  };

  programs.podman = {
    enable = true;
    users = hmUsers;
  };

  customs.ydotool = {
    enable = true;
    users = hmUsers;
  };

  # Mount data disk
  fileSystems."/home/${username}/Data" = {
    device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "allow_other" # allow non-root access
    ];
  };

  # Enable networking
  networking.hostName = "lappytoppy";
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
