{
  config,
  lib,
  inputs,
  self,
  pkgs,
  hostName,
  homeUser,
  homeUsers,
  homeUserNames,
  ...
}:

let
  userSessionPassword = username: "users/${username}/session";
in
{
  # Device components
  imports = [
    # Hardware
    ./hardware/hardware-configuration.nix # Include the results of the hardware scan
    ./hardware/hardware-modes.nix
    ./hardware/hw-brightness-proxy.nix # Fixup brightness control

    inputs.nur.modules.nixos.default

    ./system/file-ext.nix # File associations

    # Security
    "${self}/system/security/keyring.nix"
    "${self}/system/security/polkit.nix"

    # Secrets
    "${self}/secrets/sops-system.nix"

    # WM
    "${self}/system/wm/hyprland/hyprland.nix"
    ## Managing idle & screen lock
    "${self}/system/wm/hyprland/hyprlock-hypridle.nix"

    # Services
    "${self}/system/services/dbus.nix"
    "${self}/system/services/tuigreet.nix"

    # Fonts
    "${self}/system/fonts"

    # Programs
    "${self}/system/programs/peripherals/openrazer.nix"
    "${self}/system/programs/virtualization/podman.nix"
    "${self}/system/programs/virtualization/virt-manager.nix"
    # "${self}/system/programs/apollo.nix"
    "${self}/system/programs/brightness.nix"
    "${self}/system/programs/chromium.nix"
    "${self}/system/programs/cli-collection.nix"
    "${self}/system/programs/gnome-disks.nix"
    "${self}/system/programs/hakuneko.nix"
    "${self}/system/programs/nautilus.nix" # File manager
    "${self}/system/programs/screenshots.nix"
    "${self}/system/programs/ydotool.nix"

    # Dev
    "${self}/system/dev/adb.nix"
    "${self}/system/dev/jdk"

    # Theming
    "${self}/system/theming/stylix.nix"

    # Misc
    "${self}/modules/system/misc/battery.nix"
    "${self}/modules/system/misc/bluetooth.nix"
    "${self}/modules/system/misc/cloudflare-dns.nix"
    "${self}/modules/system/misc/lenovo-legion.nix"
    "${self}/modules/system/misc/ntsync.nix"
    "${self}/modules/system/misc/sound.nix"
    "${self}/modules/system/misc/sudo-insults.nix"
    "${self}/modules/system/misc/systemd-boot.nix"
    "${self}/modules/system/misc/zswap.nix"

    # Programs
    "${self}/modules/system/programs/comma.nix"
    "${self}/modules/system/programs/nh.nix"
    "${self}/modules/system/programs/plymoth.nix"

    # Shell
    "${self}/modules/system/shell/zsh.nix"
  ];

  # Apps
  environment.systemPackages = with pkgs; [
    tealdeer # tldr
    nix-tree # Tree view for nix packages
    # Dev
    filezilla
    postman
    obsidian
    # Misc
    bitwarden-desktop
    syncthing
    teamviewer
    termius
  ];

  # Setup users
  users.users = builtins.mapAttrs (username: userNameValue: {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.${userSessionPassword username}.path;
    description = userNameValue;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  }) homeUserNames;

  sops.secrets = lib.genAttrs (builtins.map userSessionPassword homeUsers) (username: {
    neededForUsers = true;
  });

  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];
    # Override files on rebuild
    clobberByDefault = true;

    users = lib.genAttrs homeUsers (username: {
      enable = true;
      directory = "/home/${username}";
      user = username;
    });
  };

  # Use lix
  nix.package = pkgs.lixPackageSets.latest.lix;

  # Allow running unpatched binaries
  programs.nix-ld.enable = true;

  # Services
  services.fstrim.enable = true;

  services.tailscale.enable = true;
  services.tailscale.authKeyFile = config.sops.secrets.tailscaleAuthKey.path;

  # Syncing files across devices
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = homeUser;
    key = config.sops.secrets."syncthing/key.pem".path;
    cert = config.sops.secrets."syncthing/certificate.pem".path;
    settings = {
      gui = {
        user = homeUser;
        password = config.sops.secrets."syncthing/gui-password";
      };
      folders = {
        "/home/${homeUser}/Documents/Notes" = {
          id = "notes";
        };
      };
      devices = {
        "poco-f3" = {
          id = "4B532ZA-CXVBPA4-NBEJ35R-YT63RVA-VL4WGQC-XX4LCFQ-4FYQNLU-RF6JWAP";
          name = "Poco F3";
        };
      };
    };
  };

  # Unified Remote
  services.urserver.enable = true;

  # Enable self-hosted game streaming
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # iPad as second screen
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = homeUsers;
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
        "path" = "/home/${homeUser}/Data/Share";
        "comment" = "Ah, lovely";
        "writable" = "yes";
        "public" = "yes";
        "guest only" = "yes";
        "force user" = "${homeUser}";
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
  programs.adb = {
    enable = true;
    users = homeUsers;
  };

  programs.openrazer = {
    enable = true;
    users = homeUsers;
  };

  programs.podman = {
    enable = true;
    users = homeUsers;
  };

  customs.ydotool = {
    enable = true;
    users = homeUsers;
  };

  # Mount data disk
  fileSystems."/home/${homeUser}/Data" = {
    device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "allow_other" # allow non-root access
    ];
  };

  # Speedup rebuilds by having /tmp be a tmpfs (and reducing strain on hdd/ssd)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  # https://wiki.archlinux.org/title/gaming#Increase_vm.max_map_count
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  # https://xanmod.org/
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Enable networking
  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
