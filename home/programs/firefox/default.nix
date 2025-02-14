{
  pkgs,
  lib,
  config,
  inputs',
  dotAssetsDir,
  ...
}:

let
  username = config.home.username;
  defaultProfileName = username;
  profiles = [
    defaultProfileName
    "private"
    "work"
    "movies"
    "gaming"
  ];

  # Firefox Nightly with https://github.com/MrOtherGuy/fx-autoconfig
  firefox-nightly =
    ((inputs'.firefox-nightly.packages.firefox-nightly-bin).override {
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    }).overrideAttrs
      (oldAttrs: {
        buildCommand =
          (oldAttrs.buildCommand or "")
          + ''
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
  # Extra addons can be fetched from https://gitlab.com/NetForceExplorer/firefox-addons
  addons = inputs'.firefox-addons.packages;
  coreAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Bearable browsing
    ublock-origin
    istilldontcareaboutcookies
    skip-redirect
    # Access inaccessible
    censor-tracker
    # Downloads
    addons.mdm-enhanced
    addons.imageye_image_downloader
    # General Enhancers
    darkreader # don't burn the eyes
    indie-wiki-buddy # provide better wikis
    hover-zoom-plus # enlarge image on hover
    search-by-image # search images with different search engines
    side-view # open page in sidebar
    tampermonkey # scripts manager
    addons.betterviewer # better image viewer
    # Reddit
    addons.load-reddit-images-directly
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
  ];
  coreNonPrivateOnlyAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Password manager
    bitwarden
    # YouTube
    addons.youtube_auto_like
    # Tabs management
    profile-switcher # in-browser profile switching
  ];
  tabsAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Tabs management
    multi-account-containers # split tabs into containers
    simple-tab-groups # tabs grouping
    addons.stg-plugin-group-notes # tab group notes
  ];
  homeAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # PWA (Progressive Web App) support
    pwas-for-firefox
    # GitHub
    notifier-for-github
  ];
  binaryName = "firefox-nightly";
  desktopEntry = "${binaryName}.desktop";
  linksHandler = "handlro.desktop"; # http/https links are handled via handlr for extra customizability

  linkSource = profile: fileName: {
    name = ".mozilla/firefox/${profile}/${fileName}";
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotAssetsDir}/firefox/${fileName}";
    };
  };
in
{
  programs.firefox = {
    enable = true;
    package = firefox-nightly;
    # https://mozilla.github.io/policy-templates/
    policies = {
      DontCheckDefaultBrowser = true; # Don’t check if Firefox is the default browser at startup.
      NoDefaultBookmarks = true; # Disable the creation of default bookmarks.
      PasswordManagerEnabled = false; # Remove (some) access to the password manager.
    };
    nativeMessagingHosts = with pkgs; [
      (callPackage ./firefox-profile-switcher-connector.nix { })
      firefoxpwa
    ];
    profiles = {
      # Default profile
      "${defaultProfileName}" = {
        id = 0;
        name = defaultProfileName;
        path = "${defaultProfileName}";
        isDefault = true;
        extensions = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons ++ homeAddons;
      };
      # Used by private browser overlay
      private = {
        id = 1;
        name = "private";
        path = "private";
        extensions = coreAddons;
      };
      # Separate instance for work-related things
      work = {
        id = 2;
        name = "work";
        path = "work";
        extensions = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
      };
      # Separate instance for multimedia
      movies = {
        id = 3;
        name = "movies";
        path = "movies";
        extensions = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
      };
      # Separate instance for games
      gaming = {
        id = 4;
        name = "gaming";
        path = "gaming";
        extensions = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
      };
    };
  };

  home.file = builtins.listToAttrs (
    lib.concatMap (profile: [
      (linkSource profile "chrome")
      (linkSource profile "user.js")
    ]) profiles
  );

  # Register firefox as default handler
  xdg.mimeApps.defaultApplications = {
    "text/html" = desktopEntry;
    "x-scheme-handler/http" = linksHandler;
    "x-scheme-handler/https" = linksHandler;
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
