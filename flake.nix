{
  description = "SoSeDiK's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Firefox Nightly
    firefox-nightly1.url = "github:calbrecht/f4s-firefox-nightly";
    firefox-nightly1.inputs.nixpkgs.follows = "nixpkgs";
    firefox-nightly2.url = "github:nix-community/flake-firefox-nightly";
    firefox-nightly2.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland & plugins
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:bivsk/split-monitor-workspaces/bivsk";
      inputs.hyprland.follows = "hyprland";
    };

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
