{ inputs, config, pkgs, profileName, ... }:

let inherit (import ../../profiles/${profileName}/options.nix) homeDir; in
{
  # Profile-specific apps
  environment.systemPackages = with pkgs; [
    heroic
    warp-terminal
    scrcpy
  ];

  # Allow running unpatched binaries
  programs.nix-ld.enable = true;

  # Services
  services.fstrim.enable = true;
  services.teamviewer.enable = true;

  programs.openvpn3.enable = true;
  services.openvpn.servers = {
    zaborona = {
      config = builtins.readFile (pkgs.fetchurl {
        url = "https://zaborona.help/openvpn-client-config/srv0.zaborona-help_maxroutes.ovpn";
        sha256 = "8b3f7d06bf7d55dfae4499b87dff3106517b648d74a5ae5ab977f4b5a164241c";
      });
      # config = builtins.readFile (pkgs.fetchurl {
      #   url = "https://zaborona.help/openvpn-client-config/srv0.zaborona-help-UDP-no-encryption_maxroutes.ovpn";
      #   sha256 = "b8984ae1b360887e29f99c67cd15dfce107d3c0ed507cd78f7ae14531162873a";
      # });
      # config = '' config /home/sosedik/Downloads/srv0.zaborona-help_maxroutes.ovpn '';
      updateResolvConf = true;
      autoStart = false;
    };
  };

  # Mount data disk
  fileSystems."${homeDir}/Data" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "allow_other" # allow non-root access
    ];
  };
}
