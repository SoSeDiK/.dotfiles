{ pkgs, self, ... }:

let
  # Only pull xembed-sni-proxy from plasma-workspace
  # Required for WINE apps to display tray icon properly (e.g. Blish HUD)
  xembed-sni-proxy = pkgs.runCommandNoCC "xembed-sni-proxy" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.plasma-workspace}/bin/xembedsniproxy $out/bin
  '';
  imageViewer = "org.gnome.Loupe.desktop";
  videoPlayer = "mpv.desktop";
in
{
  # Allows Blish HUD to run
  services.xembed-sni-proxy.enable = true;
  services.xembed-sni-proxy.package = xembed-sni-proxy;

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    # Images
    "image/png" = imageViewer;
    "image/apng" = imageViewer;
    "image/jpeg" = imageViewer; # + .jpg
    "image/pjpeg" = imageViewer; # + .jpg
    "image/jxl" = imageViewer;
    "image/gif" = imageViewer;
    "image/webp" = imageViewer;
    "image/svg+xml" = imageViewer; # .svg
    "image/x-icon" = imageViewer; # .ico
    "image/avif" = imageViewer;
    "image/bmp" = imageViewer;
    "image/tiff" = imageViewer; # + .tif
    "image/x-tiff" = imageViewer; # + .tif
    # Videos
    "video/x-matroska" = videoPlayer; # .mkv
    "video/avi" = videoPlayer;
    "video/x-msvideo" = videoPlayer; # .avi
    "video/mp4" = videoPlayer;
    "video/mpeg" = videoPlayer;
    "video/ogg" = videoPlayer;
    "video/webm" = videoPlayer;
  };
  xdg.mimeApps.associations.added = {
    "application/x-portable-anymap" = imageViewer; # .pnm
    "image/x-portable-anymap" = imageViewer; # .pnm
  };

  # Custom handlr rules
  xdg.configFile."handlr/handlr.toml".source =
    (pkgs.formats.toml { }).generate "handlr-config" {
      enable_selector = false;
      selector = "rofi -dmenu -i -p 'Open With: '";
      term_exec_args = "";
      handlers = [
        # GW 2 thingies
        {
          exec = "${self}/user/files/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?.*guildwars2\.com.*"
            "(https://)?gw2efficiency\.com.*"
            "(https://)?gw2crafts\.net.*"
            "(https://)?blishhud\.com.*"
          ];
        }
        # Any other http & https URLs since handlr is a default handler for them
        {
          exec = "${self}/user/files/scripts/firefox-open.sh default %u";
          regexes = [ "^(http|https)://.*\..+$" ];
        }
      ];
    };
}
