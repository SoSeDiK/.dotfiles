{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hyprfreeze";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "zerodya";
    repo = "hyprfreeze";
    rev = "v${version}";
    hash = "sha256-l2dXEsDPqq97d+KosAQIeKidMvw2Ma/ynIfi2hyRUJg=";
  };

  installPhase = ''
    runHook preInstall

    # Install files
    mkdir -p $out/bin
    install -Dm755 hyprfreeze $out/bin/hyprfreeze

    runHook postInstall
  '';
}
