{ config, pkgs, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) username homeDir flakeDir;
in
{
  # Fonts are nice to have
  # List installed fonts: fc-list
  fonts.packages = with pkgs; [
    # Load only specified nerdfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" "Ubuntu" ]; })
    font-awesome
    (callPackage ./apple-fonts { }) # Mostly for use by Firefox theme
  ];

  # Enable custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  fonts.fontDir.enable = true;
  # Copy custom fonts
  systemd.services.libvirtd = {
    preStart =
      ''
        # Just in case. Could be deleted, and copy fails in that case.
        mkdir -p ${homeDir}/.local/share/fonts
        # Copy custom fonts
        cp -r ${flakeDir}/system/fonts/fonts/* ${homeDir}/.local/share/fonts
        # Fix fonts owner from root back to the user
        chown -R ${username}:users ${homeDir}/.local/share/fonts
      '';
  };

  # Add custom keyboard layout (ruu)
  console.useXkbConfig = true;
  services.xserver = {
    xkb.extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [ "ru" ];
      symbolsFile = ./layouts/ruu.xkb;
    };
  };
}
