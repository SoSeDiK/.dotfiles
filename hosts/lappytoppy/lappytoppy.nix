args@{
  self,
  pkgs,
  ...
}:

let
  sysTimezone = "Europe/Kyiv";
  sysLocale = "en_US.UTF-8"; # System locale
  sysExtraLocale = "uk_UA.UTF-8"; # Time/date/currency/etc. locale

  dualsensectl = pkgs.dualsensectl.overrideAttrs (oldAttrs: {
    version = "0.8-dev";
    src = pkgs.fetchFromGitHub {
      owner = "nowrep";
      repo = "dualsensectl";
      rev = "pull/48/head";
      hash = "sha256-tJpVFCJ9yTNh3Mj3LFZxCMfF6N/PEA7LNVlzyIh6jPw=";
    };
  });
  android-studio = pkgs.symlinkJoin {
    name = "android-studio-emulator-fix";
    paths = [
      (pkgs.android-studio.overrideAttrs (attrs: {
        forceWayland = true;
      }))
    ];
    postBuild = ''
      actual_file=$(readlink -f "$out/share/applications/android-studio.desktop")
      rm "$out/share/applications" # Is a symlink
      mkdir "$out/share/applications"
      sed 's|^Exec=.*|Exec=env -u QT_QPA_PLATFORM android-studio|' "$actual_file" > "$out/share/applications/android-studio.desktop"
    '';
  };
in
{
  imports = [
    # Games
    "${self}/modules/system/gaming/gamemode.nix"
    "${self}/modules/system/gaming/gamescope.nix"
    "${self}/modules/system/gaming/no-gamepad-touchpad-mouse.nix"
    "${self}/modules/system/gaming/steam.nix"

    # Dev
    "${self}/modules/system/dev/jdk"
    "${self}/modules/system/dev/adb.nix"

    # Programs
    "${self}/modules/system/programs/nautilus.nix"
    "${self}/modules/system/programs/nwg-displays.nix"
    "${self}/modules/system/programs/walker.nix"

    # Theming
    "${self}/modules/system/theming/noto-emoji-plus.nix"
    "${self}/modules/system/theming/stylix.nix"

    # WM
    (import "${self}/modules/system/wm/hyprland.nix" (
      args
      // {
        withPlugins = true;
        hyprbars = true;
        hyprexpo = true;
        hyprwinwrap = true;
        hypr-dynamic-cursors = true;
        hyprsplit = true;
        hyprgrass = false;
      }
    ))
  ];

  environment.systemPackages = with pkgs; [
    # Social
    equibop # Discord client
    # Gaming
    heroic # Epic Games launcher
    prismlauncher # Minecraft launcher
    space-cadet-pinball # Good Old Pinball
    dualsensectl
    # Media
    stremio # video streaming
    # Dev
    (jetbrains.idea-community-bin.overrideAttrs (attrs: {
      forceWayland = true;
    }))
    android-studio
    # (android-studio.overrideAttrs (attrs: {
    #   forceWayland = true;
    # }))
    # Misc
    resources # Process manager
    qdirstat # Space management
    libqalculate # calc for walker
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(capslock)";
          };
          "capslock:C-S-M" = { };
        };
      };
    };
  };

  # Time & internationalization properties
  time.timeZone = sysTimezone;
  i18n.defaultLocale = sysLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = sysExtraLocale;
    LC_IDENTIFICATION = sysExtraLocale;
    LC_MEASUREMENT = sysExtraLocale;
    LC_MONETARY = sysExtraLocale;
    LC_NAME = sysExtraLocale;
    LC_NUMERIC = sysExtraLocale;
    LC_PAPER = sysExtraLocale;
    LC_TELEPHONE = sysExtraLocale;
    LC_TIME = sysExtraLocale;
  };

  ### HACKS ### // As in, remove once not needed

  # TODO remove, required by stremio; https://github.com/NixOS/nixpkgs/issues/437992
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];
}
