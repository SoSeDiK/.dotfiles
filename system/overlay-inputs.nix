{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system config;
      };
    })
  ];
}
