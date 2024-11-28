{ pkgs, self }:

pkgs.stdenv.mkDerivation {
  pname = "NeoFont";
  version = "1.0";

  src = "${self}/assets/fonts/Custom/TrueType/NeoFont";

  installPhase = ''
    install -Dm644 *.ttf -t $out/share/fonts/truetype
  '';
}
