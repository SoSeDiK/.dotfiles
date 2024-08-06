{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g # ntfs support
    jmtpfs # MTP mounting
    udisks
    gnome-disk-utility # GUI wrapper for udisks
    gparted

    # extra disk tools
    ventoy-full
  ];

  services.gvfs.enable = true; # MTP
}
