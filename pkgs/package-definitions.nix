{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.syngestures = pkgs.callPackage ./syngestures { };
      packages.github-desktop-plus = pkgs.callPackage ./github-desktop-plus { };
      packages.noto-emoji-plus = pkgs.callPackage ./fonts/noto-emoji-plus { };
      packages.bibata-hyprcursors-modern-ice = pkgs.callPackage ./bibata-hyprcursor {
        variant = "modern";
        baseColor = "#FFFFFF";
        outlineColor = "#000000";
        watchBackgroundColor = "#FFFFFF";
        colorName = "ice";
      };
    };
}
