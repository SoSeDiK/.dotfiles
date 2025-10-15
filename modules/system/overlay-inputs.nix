{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: _prev: {
      master = import inputs.nixpkgs-master {
        inherit (final) system config;
      };
      small = import inputs.nixpkgs-unstable-small {
        inherit (final) system config;
      };
    })
  ];
}
