{ pkgs, config, inputs, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) flakeDir username;

  defaultProfileName = username;

  profiles = [
    "${defaultProfileName}"
    "private"
    "work"
    "movies"
    "gaming"
  ];

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
  # addons = builtins.removeAttrs
  #   (pkgs.callPackage ./addons.nix {
  #     inherit (config.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  #   }) [ "override" "overrideDerivation" ];
  coreAddons = with config.nur.repos.rycee.firefox-addons; [
    # Bearable browsing
    ublock-origin
    istilldontcareaboutcookies
    # Some privacy?
    privacy-badger
    decentraleyes
    # Password manager
    bitwarden
    # Tabs management
    multi-account-containers # split tabs into containers
    simple-tab-groups # tabs grouping
    # General Enhancers
    darkreader # don't burn the eyes
    indie-wiki-buddy # provide better wikis
    search-by-image # search images with different search engines
    side-view # open page in sidebar
    tampermonkey # scripts manager
    # Twitch
    betterttv
    # Steam
    augmented-steam
    # YouTube
    sponsorblock
    return-youtube-dislikes
    enhancer-for-youtube
    # GitHub
    lovely-forks
    enhanced-github
    refined-github
    octolinker
    notifier-for-github
  ];
  homeAddons = with config.nur.repos.rycee.firefox-addons; [
    # Tabs management
    profile-switcher # in-browser profile switching
    # GitHub
    notifier-for-github
  ];
  # BetterViewer
  # Don't "Accept" image/webp
  # Bypass Paywalls Clean
  # Imagus
  # Load Reddit Images Directly
  # Imageye
  # Multithreaded Download Manager
  # YouTube Auto Like
  binaryName = "firefox-nightly";
  desktopEntry = "${binaryName}.desktop";
in
{
  programs.firefox = {
    enable = true;
    package = firefox-nightly;
    nativeMessagingHosts = [ (pkgs.callPackage ./firefox-profile-switcher-connector.nix { }) ];
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
      # Separate instance for games
      movies = {
        id = 2;
        name = "movies";
        path = "movies";
        extensions = coreAddons;
      };
      gaming = {
        id = 3;
        name = "gaming";
        path = "gaming";
      };
    };
  };

  # Symlink userChrome profile settings
  home.file.".mozilla/firefox/${defaultProfileName}/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  home.file.".mozilla/firefox/private/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  home.file.".mozilla/firefox/movies/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  home.file.".mozilla/firefox/gaming/chrome".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/chrome";
  # Symlink user.js settings
  home.file.".mozilla/firefox/${defaultProfileName}/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";
  home.file.".mozilla/firefox/private/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";
  home.file.".mozilla/firefox/movies/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";
  home.file.".mozilla/firefox/gaming/user.js".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/firefox/firefox_profile/user.js";

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

  # Hint Firefox Profile Switcher the binary location
  xdg.configFile."firefoxprofileswitcher/config.json".text = ''
    {"browser_binary": "${firefox-nightly}/bin/${binaryName}"}
  '';

  home.sessionVariables = {
    BROWSER = "${binaryName}";
    DEFAULT_BROWSER = "${firefox-nightly}/bin/${binaryName}";
  };
}
