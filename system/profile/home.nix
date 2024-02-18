{ config, pkgs, profileName, ... }:

let inherit (import ../../profiles/${profileName}/options.nix) homeDir; in
{
  # Services
  services.fstrim.enable = true;
  services.teamviewer.enable = true;

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
