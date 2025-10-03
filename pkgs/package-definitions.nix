{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.stremio = pkgs.callPackage ./stremio { };
      packages.noto-emoji-plus = pkgs.callPackage ./fonts/rkbdi-noto-emoji-plus { };
      packages.noto-fonts = pkgs.callPackage ./fonts/rkbdi-noto-sans { };
      packages.bibata-hyprcursors-modern-ice = pkgs.callPackage ./bibata-hyprcursor {
        variant = "modern";
        baseColor = "#FFFFFF";
        outlineColor = "#000000";
        watchBackgroundColor = "#FFFFFF";
        colorName = "ice";
      };
      packages.firefox-profile-switcher-connector =
        pkgs.callPackage ./firefox-profile-switcher-connector
          { };
    };
}
