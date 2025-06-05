{
  pkgs,
  lib,
  hmUsers,
  dotAssetsDir,
  ...
}:

let
  textEditor = "codium.desktop";
  imageViewer = "org.gnome.Loupe.desktop";
  videoPlayer = "mpv.desktop";
  archiveViewer = "org.kde.ark.desktop";
  browser = "firefox-nightly.desktop";
  linksHandler = "handlro.desktop"; # http/https links are handled via handlr for extra customizability
in
{
  environment.systemPackages = with pkgs; [
    handlr-regex # xdg-open replacement; handle URLs/files apps
    # Workaround for apps invoking desktop entry directly
    (makeDesktopItem {
      name = "handlro";
      desktopName = "handlro";
      exec = "${handlr-regex}/bin/handlr open \"%U\"";
      mimeTypes = [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      terminal = true;
      noDisplay = true;
    })
    (lib.hiPrio (writeShellScriptBin "xdg-open" "handlr open \"$@\"")) # Proxy xdg-open to handlr
    (writeShellScriptBin "xterm" "handlr launch x-scheme-handler/terminal -- \"$@\"") # Proxy xterm to handlr
  ];

  # Custom handlr rules
  hjem.users = lib.genAttrs hmUsers (username: {
    files.".config/handlr/handlr.toml".source = (pkgs.formats.toml { }).generate "handlr-config" {
      enable_selector = false;
      selector = "rofi -dmenu -i -p 'Open With: '";
      term_exec_args = "";
      handlers = [
        # GW 2 thingies
        {
          exec = "${dotAssetsDir}/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?.*guildwars2\.com.*"
            "(https://)?gw2efficiency\.com.*"
            "(https://)?gw2crafts\.net.*"
            "(https://)?blishhud\.com.*"
          ];
        }
        # Terraria
        {
          exec = "${dotAssetsDir}/scripts/firefox-open.sh gaming %u";
          regexes = [
            "(https://)?terraria\.wiki\.gg.*"
            "(https://)?calamitymod\.wiki\.gg.*"
          ];
        }
        # Any other http & https URLs since handlr is a default handler for them
        {
          # exec = "${dotAssetsDir}/scripts/test.sh %u";
          exec = "${dotAssetsDir}/scripts/firefox-open.sh default %u";
          regexes = [ "^(http|https):.+$" ];
        }
      ];
    };
  });

  xdg.mime.defaultApplications = {
    # Misc
    "inode/directory" = "org.gnome.Nautilus.desktop";
    # Text
    "text/plain" = textEditor;
    "text/x-patch" = textEditor; # .patch
    "text/x-java" = textEditor; # .patch
    # Browser
    "text/html" = browser;
    "x-scheme-handler/http" = linksHandler;
    "x-scheme-handler/https" = linksHandler;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
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
    # Archives
    "application/zip" = archiveViewer;
    "application/x-zip-compressed" = archiveViewer;
    "application/vnd.rar" = archiveViewer;
    "application/x-7z-compressed" = archiveViewer;
    "application/java-archive" = archiveViewer;
    "application/x-java-archive" = archiveViewer;
    "application/gzip" = archiveViewer;
    "application/x-gzip" = archiveViewer;
    "application/x-tar" = archiveViewer;
  };
  xdg.mime.addedAssociations = {
    "application/x-portable-anymap" = imageViewer; # .pnm
    "image/x-portable-anymap" = imageViewer; # .pnm
  };
}
