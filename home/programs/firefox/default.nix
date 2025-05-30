{
  pkgs,
  lib,
  config,
  inputs,
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

  defaultSearchEngine = "ddg"; # DuckDuckGo
  dailyUpdateInterval = 24 * 60 * 60 * 1000;
  searchEngines = {
    "google".metaData.hidden = true; # Using Google with forced English instead
    "bing".metaData.hidden = true;
    "ddg".metaData.alias = "!d";
    "youtube".metaData.alias = "!y";
    "Google (English)" = {
      urls = [ { template = "https://www.google.com/search?hl=en&gl=us&lr=lang_en&q={searchTerms}"; } ];
      icon = "https://www.google.com/favicon.ico";
      updateInterval = dailyUpdateInterval;
      definedAliases = [ "!g" ];
    };
    "Google Images" = {
      urls = [ { template = "https://google.com/search?tbm=isch&q={searchTerms}&tbs=imgo:1"; } ];
      icon = "https://www.google.com/favicon.ico";
      updateInterval = dailyUpdateInterval;
      definedAliases = [ "!gi" ];
    };
    "GitHub" = {
      urls = [ { template = "https://github.com/search?utf8=%E2%9C%93&q={searchTerms}"; } ];
      icon = "https://www.github.com/favicon.ico";
      updateInterval = dailyUpdateInterval;
      definedAliases = [ "!gh" ];
    };
    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "!np" ];
    };
    "Nix Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "!no" ];
    };
  };

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
    enhancer-for-youtube
    # GitHub
    lovely-forks
    enhanced-github
    refined-github
    octolinker
    addons.patch-roulette
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
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DontCheckDefaultBrowser = true; # Do not check for default browser at startup.
      DisableAppUpdate = true; # App updates are handled with nix.
      DisableTelemetry = true; # No.
    };
    profiles = {
      # Default profile
      "${defaultProfileName}" = {
        id = 0;
        name = defaultProfileName;
        path = "${defaultProfileName}";
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
      };
    };
  };

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
        extensions.packages = coreAddons ++ coreNonPrivateOnlyAddons ++ tabsAddons ++ homeAddons;
        search = {
          default = defaultSearchEngine;
          privateDefault = defaultSearchEngine;
          engines = searchEngines;
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
          engines = searchEngines;
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
          engines = searchEngines;
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
          engines = searchEngines;
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
          engines = searchEngines;
          force = true;
        };
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
