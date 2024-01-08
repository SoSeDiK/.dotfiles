{ config, pkgs, username, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g # ntfs support
    jmtpfs # MTP mounting
    udisks
    gnome.gnome-disk-utility # GUI wrapper for udisks

    # extra disk tools
    ventoy-full
  ];

  services.gvfs.enable = true; # MTP

  # Mount data disk
  fileSystems."/home/${username}/Data" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "allow_other" # allow non-root access
    ];
  };
}
