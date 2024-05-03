{ pkgs, config, profileName, ... }:

let
  inherit (import ../../../profiles/${profileName}/options.nix) flakeDir;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    extensions = with pkgs.vscode-extensions; [
      # UI / Visual
      zhuangtongfa.material-theme # One Dark Pro
      streetsidesoftware.code-spell-checker # language packs are installed manually
      esbenp.prettier-vscode
      # GitHub
      waderyan.gitblame
      # Utils
      ms-vscode.hexeditor
      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      # Python
      ms-python.python
      # C/C++ dev
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      llvm-vs-code-extensions.vscode-clangd
    ];
  };

  home.packages = with pkgs; [
    nil # nix auto completion
    nixpkgs-fmt # nix formatter
    # C/C++
    cmake
    clang-tools
  ];

  home.sessionVariables = {
    EDITOR = "codium --wait";
  };

  xdg.mimeApps.defaultApplications = {
    "text/x-patch" = "codium.desktop"; # .patch
    "text/x-java" = "codium.desktop"; # .patch
  };

  xdg.configFile."VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/settings.json";
  xdg.configFile."VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/user/apps/codium/keybindings.json";
}
