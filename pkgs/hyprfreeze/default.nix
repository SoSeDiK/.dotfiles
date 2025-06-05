{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hyprfreeze";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "zerodya";
    repo = "hyprfreeze";
    rev = "6b674166ba88a37da4136a87b4fa756d3aef601f";
    hash = "sha256-iMFSbMRVO3yOBZvCzx0BAb26KEETE7Nb+960B24r+W4=";
  };

  installPhase = ''
    runHook preInstall

    # Install files
    mkdir -p $out/bin
    install -Dm755 hyprfreeze $out/bin/hyprfreeze

    runHook postInstall
  '';
}
