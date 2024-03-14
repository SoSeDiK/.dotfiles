{
  description = "SoSeDiK's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Firefox Nightly
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & plugins
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shadower.url = "github:n3oney/shadower";

    ags.url = "github:Aylur/ags";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, impermanence, ... } @ inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        lappytoppy = nixpkgs.lib.nixosSystem {
          specialArgs = {
            profileName = "lappytoppy";
            inherit inputs;
            inherit nixos-hardware;
          };
          modules = [
            (./profiles/lappytoppy/configuration.nix)
            #impermanence.nixosModules.impermanence TODO
          ];
        };
      };
      homeConfigurations = {
        lappytoppy = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            profileName = "lappytoppy";
            inherit inputs;
            inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
          };
          modules = [
            (./profiles/lappytoppy/home.nix)
          ];
        };
      };
    };
}
