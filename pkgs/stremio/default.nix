# Source: https://codeberg.org/nuko/walkure/src/commit/36af1fbf5f08e2c20e1c63f51a692daad82ce154/nix/packages/stremio-linux-shell.nix
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  gtk3,
  mpv,
  libappindicator,
  libcef,
  makeWrapper,
  nodejs,
  # fetchurl,
  ...
}:
let
  # cef-rs expects a specific directory layout
  # Copied from https://github.com/NixOS/nixpkgs/pull/428206 because im lazy
  cef-path = stdenv.mkDerivation {
    pname = "cef-path";
    version = libcef.version;
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out"
      find ${libcef}/lib -type f -name "*" -exec cp {} $out/ \;
      find ${libcef}/libexec -type f -name "*" -exec cp {} $out/ \;
      cp -r ${libcef}/share/cef/* $out/
      mkdir -p "$out/include"
      cp -r ${libcef}/include/* "$out/include/"
    '';
    postFixup = ''
      strip $out/*.so*
    '';
  };

in
rustPlatform.buildRustPackage (finalAttrs: {
  name = "stremio-linux-shell";
  version = "1.0.0-beta.11";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FNAeur5esDqBoYlmjUO6jdi1eC83ynbLxbjH07QZ++E=";
  };

  cargoHash = "sha256-9/28BCG51jPnKXbbzzNp7KQLMkLEugFQfwszRR9kmUw=";

  # The build scripts tries to download CEF binaries by default.
  # Probably overkill since setting CEF_PATH should skip downloading binaries.
  buildFeatures = [
    "offline-build"
  ];

  buildInputs = [
    openssl
    gtk3
    mpv
    libcef
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps

    mv $out/bin/stremio-linux-shell $out/bin/stremio
    cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg


    wrapProgram $out/bin/stremio \
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator ]} \
       --prefix PATH : ${lib.makeBinPath [ nodejs ]}'';

  env.CEF_PATH = cef-path;

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    # (Server-side) 4.x versions of the web UI are closed-source
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      # unfree
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
      { name = "nuko"; }
    ];
    platforms = lib.platforms.linux;
  };
})
