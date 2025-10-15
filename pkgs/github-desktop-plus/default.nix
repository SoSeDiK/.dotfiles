{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  buildPackages,
  gnome-keyring,
  libsecret,
  git,
  git-lfs,
  curlWithGnuTls,
  nss,
  nspr,
  xorg,
  libdrm,
  alsa-lib,
  cups,
  libgbm,
  systemdLibs,
  openssl,
  libglvnd,
  # Extras
  glib,
  xdg-utils,
}:

let
  pname = "github-desktop-plus";
  version = "3.5.3.10";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pol-rivero/github-desktop-plus/releases/download/v${version}/GitHubDesktopPlus-v${version}-linux-x86_64.deb";
    sha256 = "sha256-8Rb0+Ch6WCCVgg2YtZDaM4Jjo58uip8UsptT5bpvRS8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [
    gnome-keyring
    xorg.libXdamage
    xorg.libX11
    libsecret
    git
    git-lfs
    curlWithGnuTls
    nss
    nspr
    libdrm
    alsa-lib
    cups
    libgbm
    openssl
    # Extras
    glib
    xdg-utils
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $TMP/${pname} $out/{opt,bin}
    cp $src $TMP/${pname}.deb
    ar vx ${pname}.deb
    tar --no-overwrite-dir -xvf data.tar.zst -C $TMP/${pname}/
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    cp -R $TMP/${pname}/usr/share $out/
    cp -R $TMP/${pname}/usr/lib/${pname}/* $out/opt/
    ln -sf $out/opt/${pname} $out/bin/${pname}

    rm -rf $out/opt/resources/app/git
    ln -s ${git} $out/opt/resources/app/git

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true}}"
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]}
      --set PATH "${glib}/bin:$PATH"
    )
  '';

  runtimeDependencies = [
    systemdLibs
  ];

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com/";
    license = lib.licenses.mit;
    mainProgram = pname;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
