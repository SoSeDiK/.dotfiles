{
  description = "SoSeDiK's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR"; # Nix User Repository

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";

    nix-gaming.url = "github:fufexan/nix-gaming";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Firefox Nightly
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & plugins
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=4cdddcfe466cb21db81af0ac39e51cc15f574da9"; # TODO unpin
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprcursor.url = "github:hyprwm/hyprcursor";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    shadower.url = "github:n3oney/shadower";
    ags.url = "github:Aylur/ags";
  };

  outputs = { nixpkgs, nixos-hardware, nur, home-manager, impermanence, ... } @ inputs:
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
            nur.nixosModules.nur
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
            nur.nixosModules.nur
            (./profiles/lappytoppy/home.nix)
          ];
        };
      };
    };
}
