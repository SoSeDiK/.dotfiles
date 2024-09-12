{ inputs, config, lib, pkgs, profileName, ... }:

let inherit (import ../../profiles/${profileName}/options.nix) homeDir username; in
{
  # Profile-specific imports
  imports = [
    # Java dev
    ../dev/jdk
    # Misc
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # Profile-specific apps
  environment.systemPackages = with pkgs; [
    qdirstat
  ];

  # Allow running unpatched binaries
  programs.nix-ld.enable = true;

  # Run software via , (comma) without installing it
  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false;

  # Wayland auto clicker workaround
  programs.ydotool.enable = true;
  users.users.${username}.extraGroups = [ "${config.programs.ydotool.group}" ];

  # Services
  services.fstrim.enable = true;
  services.teamviewer.enable = true;

  services.tailscale.enable = true;
  services.tailscale.authKeyFile = config.sops.secrets.tailscaleAuthKey.path;

  # iPad as second screen
  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ username ];
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
        "path" = "${homeDir}/Data/Share";
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
  services.openvpn.servers = {
    zaborona = {
      config = builtins.readFile (pkgs.fetchurl {
        url = "https://zaborona.help/openvpn-client-config/srv0.zaborona-help_maxroutes.ovpn";
        sha256 = "8b3f7d06bf7d55dfae4499b87dff3106517b648d74a5ae5ab977f4b5a164241c";
      });
      updateResolvConf = true;
      autoStart = false;
    };
  };

  # Mount data disk
  fileSystems."${homeDir}/Data" = {
    device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "allow_other" # allow non-root access
    ];
  };

  # For some reason home-manager as module can't specify this
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01" # linux-wallpaperengine
  ];
}
