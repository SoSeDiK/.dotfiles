{ config, pkgs, username, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g # ntfs support
    jmtpfs # MTP mounting
    udisks
    gnome.gnome-disk-utility # GUI wrapper for udisks
  ];

  services.gvfs.enable = true; # MTP

  fileSystems."/home/${username}/Data" =
  { device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [
      "allow_other" # allow non-root access
    ];
  };
}
