{ pkgs, ... }:

let
  # Only pull xembed-sni-proxy from plasma-workspace
  # Converts legacy xembed tray icons to SNI onces, required for WINE apps (e.g., Blish HUD, Wallpaper Engine)
  xembed-sni-proxy = pkgs.runCommandNoCC "xembed-sni-proxy" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.kdePackages.plasma-workspace}/bin/xembedsniproxy $out/bin
  '';
in
{
  # Allows WINE icons to show up in tray
  services.xembed-sni-proxy = {
    enable = true;
    package = xembed-sni-proxy;
  };
}
