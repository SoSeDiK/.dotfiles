{
  inputs,
  self,
  withSystem,
  ...
}:

{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      inherit (inputs.nixpkgs.lib.lists) concatMap;

      mkNixosConfig =
        hostName: homeUserNames:
        withSystem "x86_64-linux" (
          ctx@{
            config,
            self',
            inputs',
            ...
          }:
          let
            homeUsers = builtins.attrNames homeUserNames;
            homeUser = builtins.head homeUsers;
            flakeDir = "/home/${homeUser}/.dotfiles";
          in
          nixosSystem {
            specialArgs = {
              inherit
                inputs
                self
                self'
                inputs'
                flakeDir
                hostName
                homeUser
                homeUsers
                homeUserNames
                ;
            };
            modules = [
              # System options
              (./. + "/${hostName}/configuration.nix")

              # Add extra pkg inputs
              "${self}/modules/system/overlay-inputs.nix"

              # Home management
              "${self}/modules/system/misc/home-manager.nix"
              {
                home-manager.extraSpecialArgs = {
                  inherit
                    inputs
                    self
                    self'
                    inputs'
                    flakeDir
                    hostName
                    ;
                };
              }
              inputs.hjem.nixosModules.default
            ]
            ++ (concatMap (username: [
              {
                home-manager.users."${username}" = {
                  programs.home-manager.enable = inputs.nixpkgs.lib.mkDefault true;

                  home.username = username;
                  home.homeDirectory = "/home/${username}";

                  imports = [ "${self}/hosts/${hostName}/hmu_${username}.nix" ];
                };

              }
            ]) homeUsers);
          }
        );

    in
    {
      lappytoppy = mkNixosConfig "lappytoppy" {
        sosedik = "SoSeDiK";
      };
    };
}
