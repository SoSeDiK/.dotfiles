{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hyprfreeze";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "zerodya";
    repo = "hyprfreeze";
    rev = "v${version}";
    hash = "sha256-iMFSbMRVO3yOBZvCzx0BAb26KEETE7Nb+960B24r+W4=";
  };

  installPhase = ''
    runHook preInstall

    # Install files
    mkdir -p $out/bin
    install -Dm755 hyprfreeze $out/bin/hyprfreeze

    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility to suspend a game process (and other programs) in Hyprland and Sway";
    homepage = "https://github.com/Zerodya/hyprfreeze";
    license = licenses.mit;
  };
}
