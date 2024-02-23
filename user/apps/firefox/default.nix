{ pkgs, config, inputs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) homeDir flakeDir;
  profile = "w2uqqpwc.default"; # «xxxxxxxx.profile_name» profile in ~/.mozilla/firefix/
  firefox-base = (pkgs.firefox).overrideAttrs (oldAttrs: {
    # Add support for https://github.com/MrOtherGuy/fx-autoconfig
    buildCommand = (oldAttrs.buildCommand or "") + ''
      firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
    '';
  });
  firefox-nightly-temp = (inputs.firefox-nightly2.packages.${pkgs.system}.firefox-nightly-bin).overrideAttrs (oldAttrs: {
    # Add support for https://github.com/MrOtherGuy/fx-autoconfig
    buildCommand = (oldAttrs.buildCommand or "") + ''
      firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
      mkdir -p $firefoxDir/browser/defaults/preferences
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
    '';
  });
  firefox-nightly = (pkgs.latest.firefox-nightly-bin).overrideAttrs (oldAttrs: {
    # Add support for https://github.com/MrOtherGuy/fx-autoconfig
    buildCommand = (oldAttrs.buildCommand or "") + ''
      firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
      ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
    '';
  });
  #ama = inputs.firefox-nightly1.legacyPackages.${pkgs.system}.firefox-nightly;
in
{
  home.packages = with pkgs; [
    firefox-base
  ];
  programs.firefox = {
    enable = true;
    # package = firefox-nightly;
    package = inputs.firefox-nightly2.packages.${pkgs.system}.firefox-nightly-bin;
  };

  nixpkgs.overlays = [
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
    #         ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
    #         ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
    #         mkdir -p $firefoxDir/browser/defaults/preferences
    #         ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
    #       '';
    #     });
    #   })
    # (final: prev: {
    #   firefox = (prev.firefox).overrideAttrs (oldAttrs: {
    #     # Add support for https://github.com/MrOtherGuy/fx-autoconfig
    #     buildCommand = (oldAttrs.buildCommand or "") + ''
    #       firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)
    #       ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/config.js $firefoxDir/config.js
    #       ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/defaults/pref/config-prefs.js
    #       mkdir -p $firefoxDir/browser/defaults/preferences
    #       ln -sf ${flakeDir}/user/apps/firefox/firefox_profile/userChromeJS/defaults/pref/config-prefs.js $firefoxDir/browser/defaults/preferences/config-prefs.js
    #     '';
    #   });
    # })
  ];

  # Symlink userChrome profile settings
  home.file."${homeDir}/.mozilla/firefox/${profile}/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  # Symlink user.js settings
  xdg.configFile."${homeDir}/.mozilla/firefox/${profile}/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";

  # Register firefox as default handler
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  # /nix/store/m818gvh5barccab2avhkc2y7jpmkav34-firefox-nightly-bin-124.0a1
  # /nix/store/ajqizd9w5wn3wh8q3n4jgnk68vh2gnd0-firefox-nightly-bin-unwrapped-124.0a1/./lib/firefox-bin-124.0a1/firefox-bin
}
