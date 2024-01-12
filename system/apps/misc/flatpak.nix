{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  # Has to be enabled to use flatpak
  xdg.portal.enable = true;

  # environment.systemPackages = with pkgs; [
  #   openssl_1_1 # prevents «x86_64-linux-gnu-capsule-capture-libs: warning: Dependencies of libnvidia-pkcs11.so.545.29.06 not found, ignoring: Missing dependencies: Could not find "libcrypto.so.1.1" in LD_LIBRARY_PATH» by Steam
  # ];

  programs.steam = { # TODO why the heck is this in flatpak???
    enable = true;
  };
}
