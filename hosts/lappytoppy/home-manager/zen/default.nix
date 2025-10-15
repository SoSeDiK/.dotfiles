{
  config,
  self',
  inputs,
  inputs',
  pkgs,
  lib,
  flakeDir,
  hostName,
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

  defaultSearchEngine = "ddg"; # DuckDuckGo

  # Addons list: https://raw.githubusercontent.com/nix-community/nur-combined/refs/heads/main/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix
  # Extra addons can be fetched from https://gitlab.com/NetForceExplorer/firefox-addons/-/raw/master/combined.nix
  addons = inputs'.firefox-addons.packages;
  coreAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Bearable browsing
    ublock-origin # Ad Blocker
    istilldontcareaboutcookies # Auto accept cookies on cookie banners
    skip-redirect # Skipping shortlinks/redirects
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
    adaptive-tab-bar-colour # fancier visuals
    # Reddit
    addons.load-reddit-images-directly
    addons.reddit-nsfw-unblocker
    # Twitch
    betterttv
    # Steam
    augmented-steam
    # YouTube
    sponsorblock
    dearrow
    return-youtube-dislikes
    addons.youtube-enhancer-vc
    # GitHub
    lovely-forks
    enhanced-github
    refined-github
    octolinker
    octotree
    addons.patch-roulette
  ];
  coreNonPrivateOnlyAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Password manager
    bitwarden
    # YouTube
    addons.youtube_auto_like
    # Tabs management
    # profile-switcher # in-browser profile switching
  ];
  tabsAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # Tabs management
    multi-account-containers # split tabs into containers
    # simple-tab-groups # tabs grouping
    # addons.stg-plugin-group-notes # tab group notes
  ];
  homeAddons = with pkgs.nur.repos.rycee.firefox-addons; [
    # PWA (Progressive Web App) support
    # pwas-for-firefox
    # GitHub
    notifier-for-github
  ];

  linkSource = profile: fileName: {
    name = ".zen/${profile}/${fileName}";
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/hosts/${hostName}/home-manager/firefox/data/${fileName}";
    };
  };
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    policies = {
      DontCheckDefaultBrowser = true; # Don’t check if Firefox is the default browser at startup.
      NoDefaultBookmarks = true; # Disable the creation of default bookmarks.
      PasswordManagerEnabled = false; # Remove (some) access to the password manager.
    };

    nativeMessagingHosts = with pkgs; [
      self'.packages.firefox-profile-switcher-connector
      firefoxpwa
    ];

    profiles = {
      # Default profile
      "${defaultProfileName}" = {
        id = 0;
        name = defaultProfileName;
        path = "${defaultProfileName}";
        isDefault = true;
        extensions.packages = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons ++ homeAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          #   engines = searchEngines;
          force = true;
        };
      };
      # Used by private browser overlay
      private = {
        id = 1;
        name = "private";
        path = "private";
        extensions.packages = coreAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          #   engines = searchEngines;
          force = true;
        };
      };
      # Separate instance for work-related things
      work = {
        id = 2;
        name = "work";
        path = "work";
        extensions.packages = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          # engines = searchEngines;
          force = true;
        };
      };
      # Separate instance for multimedia
      movies = {
        id = 3;
        name = "movies";
        path = "movies";
        extensions.packages = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          # engines = searchEngines;
          force = true;
        };
      };
      # Separate instance for games
      gaming = {
        id = 4;
        name = "gaming";
        path = "gaming";
        extensions.packages = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          # engines = searchEngines;
          force = true;
        };
      };
    };
  };

  # Symlink browser options
  home.file = builtins.listToAttrs (
    lib.concatMap (profile: [
      # (linkSource profile "chrome")
      (linkSource profile "user.js")
    ]) profiles
  );

  stylix.targets.zen-browser.profileNames = profiles;
}
