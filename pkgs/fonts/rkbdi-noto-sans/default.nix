{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "RDBDI-Noto-Sans";
  version = "1.0";

  src = ./.;

  installPhase = ''
    install -Dm644 *.ttf -t $out/share/fonts/truetype
  '';
}
