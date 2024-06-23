{
  description = "SoSeDiK's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/master"; # Sometimes things break # inputs.nixpkgs-pinned.legacyPackages.x86_64-linux.

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
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

    stylix.url = "github:danth/stylix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # Firefox Nightly
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & plugins
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # &rev= to pin commit
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

  outputs = { nixpkgs, nixos-hardware, nur, home-manager, stylix, impermanence, ... } @ inputs:
    let
      profileName = "lappytoppy";
      inherit (import ./profiles/${profileName}/options.nix) username;
    in
    {
      nixosConfigurations = {
        lappytoppy = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nixos-hardware;
            inherit profileName;
          };
          modules = [
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            (./profiles/lappytoppy/configuration.nix)
            #impermanence.nixosModules.impermanence TODO impermanence
            {
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit profileName;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmbackup";
              home-manager.users.${username} = import ./profiles/${profileName}/home.nix;
            }
          ];
        };
      };
    };
}
