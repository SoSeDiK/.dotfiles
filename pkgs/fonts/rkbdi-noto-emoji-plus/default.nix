# https://github.com/RadekBledowski/noto-emoji-plus
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "RDBDI-Noto-Emoji-Plus";
  version = "1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/noto
    cp NotoColorEmoji.ttf $out/share/fonts/noto
  '';
}
