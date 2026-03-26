{
  config,
  lib,
  pkgs,
  self,
  self',
  ...
}:

let
  emojiFontName = "Noto Color Emoji";
  emojiFontPackage = self'.packages.noto-emoji-plus;

  fontMatch = fontFamily: ''
    <match target="scan">
        <test name="family" compare="contains" qual="any">
            <string>${fontFamily}</string>
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
            <minus>
                <name>charset</name>
                <charset>
                    <range>
                        <int>0xe000</int>
                        <int>0xffff</int>
                    </range>
                </charset>
            </minus>
            <minus>
                <name>charset</name>
                <charset>
                    <range>
                        <int>0x100000</int>
                        <int>0x1fffff</int>
                    </range>
                </charset>
            </minus>
        </edit>
    </match>
  '';
in
{
  # Fonts are nice to have
  # List installed fonts: fc-list
  environment.systemPackages = with pkgs; [
    font-manager
  ];

  stylix = lib.mkIf config.stylix.enable {
    fonts = {
      emoji = {
        package = emojiFontPackage;
        name = emojiFontName;
      };
    };
  };

  fonts.packages = with pkgs; [
    emojiFontPackage
    nerd-fonts.symbols-only
    fira-code
    jetbrains-mono
    symbola
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     noto-fonts-color-emoji = emojiFontPackage;
  #   })
  # ];

  # Enable custom fonts dir ($XDG_DATA_HOME/fonts --> ~/.local/share/fonts)
  # Useful for quick manual tests
  fonts.fontDir.enable = true;

  # Font rules
  fonts.fontconfig = {
    useEmbeddedBitmaps = false;
    defaultFonts = {
      monospace = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "JetBrains Mono"
        "Symbola"
      ];
      sansSerif = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "DejaVu Sans"
        "Symbola"
      ];
      serif = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "DejaVu Serif"
        "Symbola"
      ];
      emoji = lib.mkForce [
        emojiFontName
        "Symbols Nerd Font Mono"
        "Symbola"
      ];
    };
    localConf = ''
      <?xml version="1.0"?>
      <fontconfig>
        ${fontMatch "serif"}
        ${fontMatch "sans"}
        ${fontMatch "monospace"}
        ${fontMatch "DejaVu"}
        ${fontMatch "Arial"}
        ${fontMatch "JetBrains"}

        <match target="font">
          <test name="family" compare="eq">
            <string>Noto Color Emoji</string>
          </test>
          <edit name="embolden" mode="assign">
            <bool>false</bool>
          </edit>
          <edit name="autohint" mode="assign">
            <bool>false</bool>
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

  # Add custom keyboard layout (ruu)
  console.useXkbConfig = true;
  services.xserver = {
    xkb.extraLayouts.ruu = {
      description = "Russian-Ukrainian United keyboard layout";
      languages = [
        "rus"
        "ukr"
        "bel"
      ];
      symbolsFile = "${self}/assets/kb-layouts/ruu.xkb";
    };
  };
}
