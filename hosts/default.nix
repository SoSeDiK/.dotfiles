{ inputs, self, withSystem, ... }:

{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (inputs.nixpkgs.lib.lists) concatMap;
    in
    {
      lappytoppy = withSystem "x86_64-linux" (ctx@{ config, inputs', ... }:
        nixosSystem {
          specialArgs = {
            inherit inputs self inputs';
          };
          modules =
            let
              profileName = "lappytoppy";
              hmUsers = [ "sosedik" ];
            in
            [
              # System options
              (./. + "/${profileName}")

              # Home manager
              "${self}/system/programs/home-manager.nix"
              {
                home-manager.extraSpecialArgs = {
                  inherit inputs self inputs';
                };
              }
            ] ++ (concatMap
              (username: [
                { home-manager.users."${username}" = import "${self}/profiles/${profileName}/${username}.nix"; }
              ])
              hmUsers);
        });
    };
}
