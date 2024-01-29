{ pkgs, config, inputs, username, ... }:

let
  profile = "w2uqqpwc.default"; # «xxxxxxxx.profile_name» profile in ~/.mozilla/firefix/
  firefox-base = (pkgs.firefox).overrideAttrs (oldAttrs: {
        # Add support for https://github.com/MrOtherGuy/fx-autoconfig
        buildCommand = (oldAttrs.buildCommand or "") + ''
          firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
          ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
          ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
        '';
      });
  firefox-nightly = (inputs.firefox-nightly2.packages.${pkgs.system}.firefox-nightly-bin).overrideAttrs (oldAttrs: {
        # Add support for https://github.com/MrOtherGuy/fx-autoconfig
        buildCommand = (oldAttrs.buildCommand or "") + ''
          firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
          ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
          ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
          mkdir -p $firefoxDir/browser/defaults/preferences
          ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
        '';
      });
  #ama = inputs.firefox-nightly.legacyPackages.${pkgs.system}.firefox-nightly;
in {
  home.packages = with pkgs; [
    firefox-base
  ];
  programs.firefox = {
    enable = true;
    package = firefox-nightly;
    # package = pkgs.latest.firefox-nightly-bin;
  };

  nixpkgs.overlays =
  let
    # Change this to a rev sha to pin
    moz-rev = "master";
    moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz"; sha256 = "sha256-+gi59LRWRQmwROrmE1E2b3mtocwueCQqZ60CwLG+gbg="; };
    nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
  in [
    # nightlyOverlay
    # (final: prev: {
    #   firefox = import (
    #     builtins.fetchTarball {
    #       url = "https://github.com/calbrecht/f4s-firefox-nightly/archive/main.tar.gz";
    #       sha256 = "sha256-mFywqgH/fZGB9gDxhJl2ltvkLkM1093p/6tjrogKgoA=";
    #     }
    #   );
    # })
    #(inputs.firefox-nightly.overlay.${pkgs.system}.firefox-nightly)
  #   (final: prev: {
  #     firefox-nightly = (prev.inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin).overrideAttrs (oldAttrs: {
  #       # Add support for https://github.com/MrOtherGuy/fx-autoconfig
  #       buildCommand = (oldAttrs.buildCommand or "") + ''
  #         firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
  #         ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
  #         ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
  #         mkdir -p $firefoxDir/browser/defaults/preferences
  #         ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
  #       '';
  #     });
  #   })
    # (final: prev: {
    #   firefox = (prev.firefox).overrideAttrs (oldAttrs: {
    #     # Add support for https://github.com/MrOtherGuy/fx-autoconfig
    #     buildCommand = (oldAttrs.buildCommand or "") + ''
    #       firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
    #       ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
    #       ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
    #       mkdir -p $firefoxDir/browser/defaults/preferences
    #       ln -sf /home/${username}/.dotfiles/user/apps/browser/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
    #     '';
    #   });
    # })
  ];

  # Symlink userChrome profile settings
  home.file."/home/${username}/.mozilla/firefox/${profile}/chrome".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/apps/browser/firefox_profile/chrome";
  # Symlink user.js settings
  xdg.configFile."/home/${username}/.mozilla/firefox/${profile}/user.js".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles/user/apps/browser/firefox_profile/user.js";

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # Register firefox as default handler
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop"; # TODO should probably be in github desktop package?
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };
}
