{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: _prev: {
      small = import inputs.nixpkgs-unstable-small {
        inherit (final) system config;
      };
    })
  ];
}
