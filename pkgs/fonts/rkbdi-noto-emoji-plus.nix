{ pkgs, self }:

pkgs.stdenv.mkDerivation {
  pname = "RDBDI-Noto-Emoji-Plus";
  version = "1.0";

  src = "${self}/assets/fonts/Google/TrueType/Noto-Color-Emoji";

  installPhase = ''
    install -Dm644 *.ttf -t $out/share/fonts/truetype
  '';
}
