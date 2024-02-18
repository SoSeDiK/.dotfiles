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
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    ags.url = "github:Aylur/ags";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, impermanence, ... }:
    let
      system = "x86_64-linux";

      wm = "hyprland"; # one of the ./system/wm
      browser = "firefox"; # one of the ./user/apps/browser
      term = "kitty"; # one of the ./user/apps/terminal
      editor = "nano";

      # Options
      timezone = "Europe/Kyiv";
      locale = "en_US.UTF-8";
      timeLocale = "uk_UA.UTF-8";
      dotfilesDir = "~/.dotfiles";

      # (!) Make sure to change in new setup!
      name = "SoSeDiK";
      username = "sosedik";
      email = "mrsosedik@gmail.com";
      hostname = "lappytoppy";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        system = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit (import ./profiles/home/options.nix) username;
            inherit wm;
            inherit nixos-hardware;
            profileName = "home";
          };
          modules = [
            (./profiles/home/configuration.nix)
            #impermanence.nixosModules.impermanence
          ];
        };
      };
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            profileName = "home";
            inherit inputs;
            inherit wm;
            inherit dotfilesDir;
            inherit name;
            inherit username;
            inherit email;
            inherit browser;
            inherit term;
            inherit editor;
          };
          modules = [
            (./profiles/home/home.nix)
          ];
        };
      };
    };
}



