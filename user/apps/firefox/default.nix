{ pkgs, config, inputs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) homeDir flakeDir;

  profile = "w2uqqpwc.default"; # «xxxxxxxx.profile_name» profile in ~/.mozilla/firefix/

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
in
{
  programs.firefox = {
    enable = true;
    package = firefox-nightly;
  };

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
}
