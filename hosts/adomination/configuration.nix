{
  config,
  lib,
  inputs,
  self,
  hostName,
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
    ./hardware/hardware-configuration.nix
    ./hardware/nixos-hardware.nix
    ./hardware/secure-boot.nix
    ./hardware/impermanence-btrfs.nix

    # Misc
    "${self}/modules/system/misc/ntsync.nix"
    "${self}/modules/system/misc/sound.nix"

    # Programs
    "${self}/modules/system/programs/comma.nix"
    "${self}/modules/system/programs/nh.nix"
  ];

  # Setup users
  users.users = builtins.mapAttrs (username: userNameValue: {
    isNormalUser = true;
    # hashedPasswordFile = config.sops.secrets.${userSessionPassword username}.path;
    description = userNameValue;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  }) homeUserNames;

  # sops.secrets = lib.genAttrs (builtins.map userSessionPassword homeUsers) (username: {
  #   neededForUsers = true;
  # });

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

  # Impermanence
  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/db/sudo"
      "/var/lib/sbctl"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostName;

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
