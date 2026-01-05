{
  config,
  lib,
  pkgs,
  self',
  ...
}:

let
  emojiFontName = "Noto Color Emoji";
  emojiFontPackage = self'.packages.noto-emoji-plus;
in
{
  stylix = lib.mkIf config.stylix.enable {
    fonts = {
      emoji = {
        package = emojiFontPackage;
        name = emojiFontName;
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # Extra font rules
  fonts.fontconfig = {
    useEmbeddedBitmaps = false;
    defaultFonts = {
      monospace = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "JetBrains Mono"
      ];
      sansSerif = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "DejaVu Sans"
      ];
      serif = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "DejaVu Serif"
      ];
      emoji = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
      ];
    };
    localConf = ''
      <?xml version="1.0"?>
      <fontconfig>
        <match target="scan">
            <test name="family" compare="contains">
                <string>serif</string>
            </test>
            <test name="family" compare="contains">
                <string>sans</string>
            </test>
            <test name="family" compare="contains">
                <string>monospace</string>
            </test>
            <test name="family" compare="contains">
                <string>DejaVu</string>
            </test>
            <test name="family" compare="contains">
                <string>JetBrains</string>
            </test>
            <edit name="charset" mode="assign" binding="same">
                <minus>
                    <name>charset</name>
                    <charset>
                        <range>
                            <int>0x1f000</int>
                            <int>0x1fffd</int>
                        </range>
                    </charset>
                </minus>
            </edit>
        </match>

        <!--
        Recognize legacy ways of writing EmojiOne family name.
        -->
        <match target="pattern">
            <test qual="any" name="family"><string>EmojiOne</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Emoji One</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>EmojiOne Color</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>EmojiOne Mozilla</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <!--
        Use Noto Color Emoji when other popular fonts are being specifically requested.

        It is quite common that websites would only request Apple and Google emoji fonts.
        These aliases will make Noto Color Emoji be selected in such cases to provide good-looking emojis.

        This obviously conflicts with other emoji fonts if you have them installed.
        -->
        <match target="pattern">
            <test qual="any" name="family"><string>Segoe UI Emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Segoe UI Symbol</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Apple Color Emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>NotoColorEmoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Android Emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Noto Emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Twitter Color Emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>JoyPixels</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Twemoji Mozilla</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>TwemojiMozilla</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>EmojiTwo</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Emoji Two</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>EmojiSymbols</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>

        <match target="pattern">
            <test qual="any" name="family"><string>Symbola</string></test>
            <edit name="family" mode="assign" binding="same"><string>Noto Color Emoji</string></edit>
        </match>
      </fontconfig>
    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      noto-fonts-color-emoji = emojiFontPackage;
    })
  ];
}
