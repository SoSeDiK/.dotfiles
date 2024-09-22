{ lib
, stdenv
, fetchFromGitHub
, cmake
, ffmpeg
, libglut
, freeimage
, glew
, glfw
, glm
, libGL
, libpulseaudio
, libX11
, libXau
, libXdmcp
, libXext
, libXpm
, libXrandr
, libXxf86vm
, lz4
, mpv
, pkg-config
, SDL2
, SDL2_mixer
, wayland
, wayland-protocols
, wayland-scanner
, zlib
}:

stdenv.mkDerivation {
  pname = "linux-wallpaperengine";
  version = "unstable-5a45c9a";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    # Upstream lacks versioned releases
    rev = "5a45c9a26b63cff96a9327946951b02023005b82";
    hash = "sha256-+h7plh4Sf1hp0fYj5f5kXd3ANVHXhflk3LwkYPvoS3w=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    # Wayland support
    wayland-scanner
  ];

  buildInputs = [
    ffmpeg
    libglut
    freeimage
    glew
    glfw
    glm
    libGL
    libpulseaudio
    libX11
    libXau
    libXdmcp
    libXext
    libXrandr
    libXpm
    libXxf86vm
    mpv
    lz4
    SDL2
    SDL2_mixer.all
    zlib
    # Wayland support
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Only;
    mainProgram = "linux-wallpaperengine";
    platforms = lib.platforms.linux;
  };
}
