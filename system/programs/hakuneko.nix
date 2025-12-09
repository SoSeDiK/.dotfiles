{ pkgs, ... }:

let
  # Stable is quite outdated, use nightly instead
  hakuneko = pkgs.hakuneko.overrideAttrs (attrs: {
    version = "8.3.4";
    src = pkgs.fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/nightly-20200705.1/hakuneko-desktop_8.3.4_linux_amd64.deb";
      sha256 = "sha256-SOmncBVpX+aTkKyZtUGEz3k/McNFLRdPz0EFLMsq4hE=";
    };
    # Launch through steam's sandbox, otherwise either broken or requires --no-sandbox
    postFixup = ''
      makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/hakuneko \
        --add-flags $out/lib/hakuneko-desktop/hakuneko \
        "''${gappsWrapperArgs[@]}"
    '';
  });
in
{
  environment.systemPackages = [
    hakuneko
  ];
}
