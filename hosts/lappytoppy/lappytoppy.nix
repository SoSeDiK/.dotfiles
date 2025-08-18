{
  self,
  pkgs,
  ...
}:

let
  sysTimezone = "Europe/Kyiv";
  sysLocale = "en_US.UTF-8"; # System locale
  sysExtraLocale = "uk_UA.UTF-8"; # Time/date/currency/etc. locale
in
{
  imports = [
    # Games
    "${self}/modules/system/gaming/gamemode.nix"
    "${self}/modules/system/gaming/gamescope.nix"
    "${self}/modules/system/gaming/steam.nix"

    # Programs
    "${self}/modules/system/programs/nwg-displays.nix"
    "${self}/modules/system/programs/walker.nix"

    # WM
    "${self}/modules/system/wm/hyprland.nix"
  ];

  environment.systemPackages = with pkgs; [
    # Social
    equibop # Discord client
    # Gaming
    heroic # Epic Games launcher
    prismlauncher # Minecraft launcher
    space-cadet-pinball # Good Old Pinball
    # Dev
    (jetbrains.idea-community-bin.overrideAttrs (attrs: {
      forceWayland = true;
    }))
    (android-studio.overrideAttrs (attrs: {
      forceWayland = true;
    }))
    # Misc
    resources # Process manager
    qdirstat # Space management
    libqalculate # calc for walker
  ];

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
}
