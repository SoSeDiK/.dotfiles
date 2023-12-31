{ config, pkgs, username, ... }:

let
  noto-fonts-color-emoji = (pkgs.noto-fonts-color-emoji).overrideAttrs (attrs: {
    # postInstall = (attrs.postInstall or "") + ''
    #   rm ${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf
    #   ln -s /home/${username}/.dotfiles/system/wm/libs/fonts ${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf
    # '';
    # installPhase = ''
    #   runHook preInstall
    #   mkdir -p $out/share/fonts/noto
    #   rm NotoColorEmoji.ttf
    #   cp /home/${username}/.dotfiles/system/wm/libs/fonts/NotoColorEmoji.ttf ./
    #   cp NotoColorEmoji.ttf $out/share/fonts/noto
    #   runHook postInstall
    # '';
  });
in {
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    # Load only specified nerdfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    iosevka
    font-awesome
  ];
  # Custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  fonts.fontDir.enable = true;

  # Custom keyboard layout
  console.useXkbConfig = true;
  services.xserver = {
    enable = true;
    extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [ "ru" ];
      symbolsFile = ./layouts/ruu.xkb;
    };
  };

  # Make custom fonts visible for Flatpaks
  # And install custom Noto Color Emoji
  # systemd.services.libvirtd = {
  #   preStart =
  #   ''
  #     ln -s /run/current-system/sw/share/X11/fonts ~/.local/share/fonts
  #   '';
  # };

      # Read-only file system........
      # ln -s /home/${username}/.dotfiles/system/wm/libs/fonts/Fonty.ttf ~/.local/share/fonts/Fonty.ttf
      # 
      # rm ${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf
      # ln -s /home/${username}/.dotfiles/system/wm/libs/fonts ${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf

  # List installed fonts: fc-list
}
