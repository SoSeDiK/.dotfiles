{ config, pkgs, username, ... }:

{
  # Fonts are nice to have
  # List installed fonts: fc-list
  fonts.packages = with pkgs; [
    # Load only specified nerdfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    iosevka
    font-awesome
    (callPackage ./apple-fonts { }) # Mostly for use by Firefox theme
  ];

  environment.systemPackages = with pkgs; [
    p7zip # 7z; also used to build apple-fonts, but is useful overall
  ];

  # Enable custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  fonts.fontDir.enable = true;
  # Copy custom fonts
  systemd.services.libvirtd = {
    preStart =
    ''
      # Just in case. Could be deleted, and copy fails in that case.
      mkdir -p /home/${username}/.local/share/fonts
      # Copy custom fonts
      cp -r /home/${username}/.dotfiles/system/wm/libs/fonts/* /home/${username}/.local/share/fonts
      # Fix fonts owner from root back to the user
      chown -R ${username}:users /home/${username}/.local/share/fonts
    '';
  };

  # Add custom keyboard layout (ruu)
  console.useXkbConfig = true;
  services.xserver = {
    extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [ "ru" ];
      symbolsFile = ./layouts/ruu.xkb;
    };
  };
}
