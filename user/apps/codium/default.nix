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
      ms-python.python
      zhuangtongfa.material-theme
      waderyan.gitblame
      esbenp.prettier-vscode
      streetsidesoftware.code-spell-checker # language packs are installed manually
      ms-vscode.hexeditor
    ];
  };

  home.packages = with pkgs; [
    nil # nix auto completion
    nixpkgs-fmt # nix formatter
  ];

  home.file.".config/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/settings.json";
  home.file.".config/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/keybindings.json";
}
