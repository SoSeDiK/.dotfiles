{ config, pkgs, username, ... }:

let
  profile = "w2uqqpwc.default"; # «xxxxxxxx.profile_name» profile in ~/.mozilla/firefix/
in {
  home.packages = with pkgs; [
    firefox
  ];

  # Symlink userChrome.css profile
  home.file."/home/${username}/.mozilla/firefox/${profile}/chrome".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/apps/browser/firefox_profile/chrome";
  # Symlink user.js settings
  xdg.configFile."/home/${username}/.mozilla/firefox/${profile}/user.js".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/apps/browser/firefox_profile/user.js";

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop";
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

}
