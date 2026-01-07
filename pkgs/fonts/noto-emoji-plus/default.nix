# https://github.com/RadekBledowski/noto-emoji-plus
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "Noto-Emoji-Plus";
  version = "16.0";

  src = ./.;

  installPhase = ''
    install -Dm755 Noto-COLRv1.ttf $out/share/fonts/noto/NotoColorEmoji.ttf
  '';
}
