{ pkgs, self }:

pkgs.stdenv.mkDerivation {
  pname = "RDBDI-Noto-Sans";
  version = "1.0";

  src = "${self}/assets/fonts/RKBDI/TrueType/Noto-Sans";

  installPhase = ''
    install -Dm644 *.ttf -t $out/share/fonts/truetype
  '';
}
