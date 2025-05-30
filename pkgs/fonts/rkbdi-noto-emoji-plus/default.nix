# https://github.com/RadekBledowski/noto-emoji-plus
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "RDBDI-Noto-Emoji-Plus";
  version = "16.0";

  src = ./.;

  installPhase = ''
    # install -Dm755 NotoColorEmojiFlags.ttf $out/share/fonts/noto/NotoColorEmojiFlags.ttf
    install -Dm755 NotoColorEmoji.ttf $out/share/fonts/noto/NotoColorEmoji.ttf
  '';
}
