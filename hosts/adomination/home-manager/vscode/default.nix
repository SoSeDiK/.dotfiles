{
  pkgs,
  config,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
    ];
  };

  # nix-ide extras
  home.packages = with pkgs; [
    nil # nix auto completion
    nixfmt-rfc-style # nix formatter
  ];

  xdg.configFile."VSCodium/User/settings.json".source = mkOutOfStoreSymlink ./settings.json;
  xdg.configFile."VSCodium/User/keybindings.json".source = mkOutOfStoreSymlink ./keybindings.json;
}
