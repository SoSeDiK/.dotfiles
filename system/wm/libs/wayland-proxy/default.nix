{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wayland-proxy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "stransky";
    repo = "wayland-proxy";
    rev = "v${version}";
    hash = "sha256-wrong";
  };

  buildInputs = [ cmake gcc pkgconfig boost ];
  outputs = ["out"];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    sh $out/src/compile
  '';

  meta = with lib; {
    homepage = "https://github.com/stransky/wayland-proxy";
    description = "Wayland proxy is load balancer between Wayland compositor and Wayland client. It prevents Wayland client to be disconnected by Wayland compositor if Wayland client is bussy or under heavy load.";
    #license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [sosedik];
    mainProgram = "wayland-proxy";
  };
}
