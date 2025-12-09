{ lib
, rustPlatform
, fetchFromGitHub
, libevdev
, pkg-config
, autoconf
, automake
, libtool
, withLogging ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "syngesture";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mqudsi";
    repo = "syngesture";
    rev = version;
    sha256 = "sha256-CgQeVXjg9Tr3anRKzQGt/PzAFN8KcMItWFEr6IL+vmc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildFeatures = lib.optional withLogging "logging";

  nativeBuildInputs = [ 
    pkg-config 
    autoconf 
    automake 
    libtool 
  ];

  buildInputs = [ 
    libevdev 
  ];

  # Add pre-build configuration for evdev-sys
  preBuild = ''
    export LIBEVDEV_SYS_USE_PKG_CONFIG=1
  '';

  meta = with lib; {
    description = "Linux Multi-Touch Protocol Userland Daemon for multi-touch gestures";
    homepage = "https://github.com/mqudsi/syngesture";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
