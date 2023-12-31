{
  description = "SoSeDiK's NixOS Flake";

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
  let
    profile = "home"; # select a profile in ./profiles
    wm = "hyprland"; # one of the ./system/wm
    browser = "firefox"; # one of the ./user/apps/browser
    term = "kitty"; # one of the ./user/apps/terminal
    editor = "nano";

    # Options
    timezone = "Europe/Kyiv";
    locale = "en_US.UTF-8";
    timeLocale = "uk_UA.UTF-8";
    dotfilesDir = "~/.dotfiles";
    system = "x86_64-linux"; # system arch

    # (!) Make sure to change in new setup!
    name = "SoSeDiK";
    username = "sosedik";
    email = "mrsosedik@gmail.com";
    hostname = "lappytoppy";

    # create patched nixpkgs
    nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
      name = "nixpkgs-patched";
      src = nixpkgs;
      patches = [
        # patches in ./patches
      ];
    };

    # configure pkgs
    pkgs = import nixpkgs-patched {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [];
    };
  in {
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
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
          (./. + "/profiles" + ("/" + profile) + "/home.nix")
        ];
      };
    };
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit wm;
          inherit timezone;
          inherit locale;
          inherit timeLocale;
          inherit name;
          inherit username;
          inherit hostname;
          inherit nixos-hardware;
        };
        modules = [
          (./. + "/profiles" + ("/" + profile) + "/configuration.nix")
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland & plugins
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    ags.url = "github:Aylur/ags";
  };
}
