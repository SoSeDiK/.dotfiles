{
  inputs,
  lib,
  pkgs,
  flakeDir,
  hostName,
  homeUsers,
  ...
}:

{
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    nil # nix auto completion
    nixfmt # nix formatter
  ];

  # VS Code itself is managed via home-manager due to its "mutable extensions" feature

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/VSCodium/User/settings.json".source = "${flakeDir}/hosts/${hostName}/system/vscode/settings.json";
      ".config/VSCodium/User/keybindings.json".source = "${flakeDir}/hosts/${hostName}/system/vscode/keybindings.json";
      ".vscode-oss/argv.json".source = "${flakeDir}/hosts/${hostName}/system/vscode/argv.json";
    };
  });
}
