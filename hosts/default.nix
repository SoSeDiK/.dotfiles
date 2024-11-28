{ inputs, self, withSystem, ... }:

{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (inputs.nixpkgs.lib.lists) concatMap;

      dotAssetsDir = "/home/sosedik/.dotfiles/assets";
    in
    {
      lappytoppy = withSystem "x86_64-linux" (ctx@{ config, inputs', ... }:
        let
          profileName = "lappytoppy";
          hmUsers = [ "sosedik" ];
        in
        nixosSystem {
          specialArgs = {
            inherit inputs self inputs' dotAssetsDir hmUsers;
          };
          modules = [
            # System options
            (./. + "/${profileName}")

            # Add extra pkg inputs
            "${self}/system/overlay-inputs.nix"

            # Home manager
            "${self}/system/programs/home-manager.nix"
            {
              home-manager.extraSpecialArgs = {
                inherit inputs self inputs' dotAssetsDir;
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
