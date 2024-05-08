{ buildFirefoxXpiAddon, lib }:
# Can be easily fetched from https://gitlab.com/NetForceExplorer/firefox-addons
#
# BetterViewer
# Don't "Accept" image/webp
# Load Reddit Images Directly
# Imageye
# Multithreaded Download Manager
# YouTube Auto Like
# [STG plugin] Group notes
{
  "betterviewer" = buildFirefoxXpiAddon {
    pname = "betterviewer";
    version = "1.0.5";
    addonId = "ademking@betterviewer";
    url = "https://addons.mozilla.org/firefox/downloads/file/4002455/betterviewer-1.0.5.xpi";
    sha256 = "01b90d2afc4dc5de93dbb2eff2cc1cbd8eac181ddefb9d9506ff36788db901a7";
    meta = with lib;
      {
        homepage = "https://github.com/Ademking/BetterViewer";
        description = "BetterViewer was designed as a replacement for the image viewing mode built into Firefox and Chrome-based web browsers. With BetterViewer you can use various keyboard shortcuts to quickly pan, zoom images, edit and a lot more!";
        license = licenses.mit;
        mozPermissions = [
          "webRequest"
          "webRequestBlocking"
          "activeTab"
          "storage"
          "*://*/*"
        ];
        platforms = platforms.all;
      };
  };
  "dont-accept-webp" = buildFirefoxXpiAddon {
    pname = "dont-accept-webp";
    version = "0.9";
    addonId = "dont-accept-webp@jeffersonscher.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4191562/dont_accept_webp-0.9.xpi";
    sha256 = "9d5177cfde905232efde79aa5b617b1a3430f896988f7034a8cd954e64d24ad6";
    meta = with lib;
      {
        homepage = "https://github.com/jscher2000/dont-accept-webp";
        description = "This extension removes image/webp and/or image/avif from the list of formats Firefox tells sites that it accepts. That discourages many servers from replacing JPEG and PNG images with WebP/AVIF. (But some may send them anyway; they aren't blocked.)";
        license = licenses.mpl20;
        mozPermissions = [
          "<all_urls>"
          "activeTab"
          "webRequest"
          "webRequestBlocking"
          "storage"
          "management"
        ];
        platforms = platforms.all;
      };
  };
  "youtube_auto_like" = buildFirefoxXpiAddon {
    pname = "youtube_auto_like";
    version = "3.9.1";
    addonId = "{21b3b6ae-1582-4db8-84b3-b6cc45a4a92c}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4263469/youtube_auto_like-3.9.1.xpi";
    sha256 = "5d39ed3efac035fb953adb58be2e4de7f6ddd9f954302e9ef75d89fc81404c02";
    meta = with lib;
      {
        description = "Automatically like YouTube videos from your favorite content creators.";
        license = licenses.mit;
        mozPermissions = [
          "activeTab"
          "storage"
          "*://youtube.com/*"
          "*://*.youtube.com/*"
        ];
        platforms = platforms.all;
      };
  };
  "mdm-enhanced" = buildFirefoxXpiAddon {
    pname = "mdm-enhanced";
    version = "3.3";
    addonId = "multithreaded-download-manager@footmen-dev.local";
    url = "https://addons.mozilla.org/firefox/downloads/file/4179832/mdm_enhanced-3.3.xpi";
    sha256 = "4c53f32b030dfd02f64aa1a5f4591e179ee742ee59118b794b9829cd416a3ebb";
    meta = with lib;
      {
        description = "Download manager with multithreaded support.";
        license = licenses.mit;
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "<all_urls>"
          "downloads"
          "downloads.open"
          "webRequest"
          "webRequestBlocking"
          "clipboardRead"
          "clipboardWrite"
          "menus"
          "menus.overrideContext"
          "notifications"
          "tabs"
        ];
        platforms = platforms.all;
      };
  };
  "load-reddit-images-directly" = buildFirefoxXpiAddon {
    pname = "load-reddit-images-directly";
    version = "1.6.1";
    addonId = "{4c421bb7-c1de-4dc6-80c7-ce8625e34d24}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4252316/load_reddit_images_directly-1.6.1.xpi";
    sha256 = "cf650e6284ddd6d4a7ece34bccf30f0d1df003ecebf328d3f8519b367b83cdc1";
    meta = with lib;
      {
        homepage = "https://github.com/nopperl/load-reddit-images-directly";
        description = "Loads reddit images directly instead of redirecting to the HTML page containing the image. This works for <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/81e40807248441ca24f789047ae28a7a8266f8ad344ea6f4977e4473d60d20e5/http%3A//i.redd.it\" rel=\"nofollow\">i.redd.it</a>, <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/8e73e8b6575335896f295209eb7b291999654798ffcb596097c6a3cafd045683/http%3A//preview.redd.it\" rel=\"nofollow\">preview.redd.it</a>, <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/7e63b0cb427894e946e7065c2badea35dadb397a6a87745849d72f65a9cad794/http%3A//external-preview.redd.it\" rel=\"nofollow\">external-preview.redd.it</a> and <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/5b712eb108fa1803f12422942e6674a8d67e9e8b02d20ccfcce6cf2cb33c934d/http%3A//www.reddit.com/media\" rel=\"nofollow\">www.reddit.com/media</a> urls.";
        license = licenses.mpl20;
        mozPermissions = [
          "activeTab"
          "storage"
          "webRequest"
          "webRequestBlocking"
          "*://i.redd.it/*"
          "*://external-preview.redd.it/*"
          "*://preview.redd.it/*"
          "*://www.reddit.com/*"
          "*://www.reddit.com/r/*"
        ];
        platforms = platforms.all;
      };
  };
  "imageye_image_downloader" = buildFirefoxXpiAddon {
    pname = "imageye_image_downloader";
    version = "1.5.3";
    addonId = "imageye@marenauta.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/3691571/imageye_image_downloader-1.5.3.xpi";
    sha256 = "fa125f891cb484f108c28c46af610dd170b1b62d13f3fbd7ac63ad7ffa7902e8";
    meta = with lib;
      {
        description = "Find and download all images on a web page.";
        mozPermissions = [ "activeTab" "downloads" "storage" ];
        platforms = platforms.all;
      };
  };
  "stg-plugin-group-notes" = buildFirefoxXpiAddon {
    pname = "stg-plugin-group-notes";
    version = "2.0.1";
    addonId = "stg-plugin-group-notes@drive4ik";
    url = "https://addons.mozilla.org/firefox/downloads/file/4094713/stg_plugin_group_notes-2.0.1.xpi";
    sha256 = "8d831263db5e43e7d1fca20ddbd661dfeb319e806f54bc44fbe07c746d5d5814";
    meta = with lib;
      {
        homepage = "https://github.com/drive4ik/simple-tab-groups";
        description = "Create notes for group";
        license = licenses.mpl20;
        mozPermissions = [
          "menus"
          "notifications"
          "storage"
          "unlimitedStorage"
        ];
        platforms = platforms.all;
      };
  };
}
