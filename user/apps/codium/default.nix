{ pkgs, config, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) flakeDir;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      arrterian.nix-env-selector
    ];
  };

  home.packages = with pkgs; [
    nixpkgs-fmt # nix formatter for codium
  ];

  home.file.".config/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/settings.json";
  home.file.".config/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/keybindings.json";
}
