{ lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) openrazer username; in
lib.mkIf (openrazer == true) {
  environment.systemPackages = with pkgs; [
    # openrazer-daemon # TODO revert when fixed
    (openrazer-daemon.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython ];
    }))
    polychromatic # Front-end control
  ];

  hardware.openrazer = {
    enable = true;
    users = [ username ];
    mouseBatteryNotifier = false;
  };
}
