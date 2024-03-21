{ pkgs, config, inputs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) homeDir flakeDir username;

  defaultProfileName = username;

  # Firefox Nightly with https://github.com/MrOtherGuy/fx-autoconfig
  firefox-nightly = (
    (inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin).override {
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    }
  ).overrideAttrs (oldAttrs: {
    buildCommand = (oldAttrs.buildCommand or "") + ''
      # Find firefox dir
      firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)

      # Function to replace symlink with destination file
      replaceSymlink() {
        local symlink_path="$firefoxDir/$1"
        local target_path=$(readlink -f "$symlink_path")
        rm "$symlink_path"
        cp "$target_path" "$symlink_path"
      }

      # Copy firefox binaries
      replaceSymlink "firefox"
      replaceSymlink "firefox-bin"
    '';
  });
  desktopEntry = "firefox.desktop";
in
{
  programs.firefox = {
    enable = true;
    package = firefox-nightly;
    profiles = {
      # Default profile
      "${defaultProfileName}" = {
        id = 0;
        name = defaultProfileName;
        path = "${defaultProfileName}";
        isDefault = true;
      };
      # Used by private browser overlay
      private = {
        id = 1;
        name = "private";
        path = "private";
      };
    };
  };

  # Symlink userChrome profile settings
  home.file.".mozilla/firefox/${defaultProfileName}/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  home.file.".mozilla/firefox/private/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  # Symlink user.js settings
  home.file.".mozilla/firefox/${defaultProfileName}/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";
  home.file.".mozilla/firefox/private/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";

  # Register firefox as default handler
  xdg.mimeApps.defaultApplications = {
    "text/html" = desktopEntry;
    "x-scheme-handler/http" = desktopEntry;
    "x-scheme-handler/https" = desktopEntry;
    "x-scheme-handler/about" = desktopEntry;
    "x-scheme-handler/unknown" = desktopEntry;
    "application/x-extension-htm" = desktopEntry;
    "application/x-extension-html" = desktopEntry;
    "application/x-extension-shtml" = desktopEntry;
    "application/xhtml+xml" = desktopEntry;
    "application/x-extension-xhtml" = desktopEntry;
    "application/x-extension-xht" = desktopEntry;
  };

  home.sessionVariables = {
    BROWSER = "firefox-nightly";
    DEFAULT_BROWSER = "${firefox-nightly}/bin/firefox";
  };
}
