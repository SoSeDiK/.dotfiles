{ config, pkgs, username, ... }:

{
  home.packages = with pkgs; [
    firefox
  ];

  # Symlink userChrome.css profile
  home.file."/home/${username}/.mozilla/firefox/fbal5m1j.default/chrome".source = ./firefox_profile/chrome;
  # Symlink user.js settings
  xdg.configFile."/home/${username}/.mozilla/firefox/fbal5m1j.default/user.js".source = ./firefox_profile/user.js;

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
