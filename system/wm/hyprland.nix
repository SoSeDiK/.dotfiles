{ inputs', pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libnotify
    libsecret
    inputs'.hyprcursor.packages.hyprcursor
    inputs'.hyprsunset.packages.hyprsunset
    hyprland-protocols
    gvfs
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # Used for file picker
    ];
    xdgOpenUsePortal = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs'.hyprland.packages.hyprland;
    # package = (inputs'.hyprland.packages.hyprland).overrideAttrs (_finalAttrs: previousAttrs: {
    #   patches = previousAttrs.patches ++ [
    #     # ./patches/patch1.patch
    #   ];
    # });
    portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
