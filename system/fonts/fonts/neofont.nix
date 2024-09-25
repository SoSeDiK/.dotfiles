{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "NeoFont";
  version = "1.0";

  src = ./Custom/TrueType;

  installPhase = ''
    install -Dm644 NeoFont/*.ttf -t $out/share/fonts/truetype
  '';
}
