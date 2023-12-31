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
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./layouts/ruu.xkb} $out
  '';
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

  # Load custom keyboard layout
  # environment.systemPackages = with pkgs; [
  #   xorg.xkbcomp
  # ];
  #services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";

  console.useXkbConfig = true;
  services.xserver = {
    enable = true;
    extraLayouts.ruu = {
      description = "My custom US layout";
      languages = [ "eng" ];
      symbolsFile = (builtins.readFile ./layouts/ruu.xkb)
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
