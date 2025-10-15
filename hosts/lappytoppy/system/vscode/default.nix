{
  inputs,
  lib,
  pkgs,
  homeUsers,
  ...
}:

{
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    nil # nix auto completion
    nixfmt-rfc-style # nix formatter
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    extensions =
      let
        ext = pkgs.vscode-marketplace-release;
      in
      with pkgs.vscode-extensions;
      [
        # UI / Visual
        zhuangtongfa.material-theme # One Dark Pro
        streetsidesoftware.code-spell-checker
        ext.streetsidesoftware.code-spell-checker-ukrainian
        ext.streetsidesoftware.code-spell-checker-russian
        esbenp.prettier-vscode

        # git
        waderyan.gitblame

        # Utils
        ms-vscode.hexeditor
        signageos.signageos-vscode-sops

        # Nix
        jnoortheen.nix-ide
        arrterian.nix-env-selector

        # QT
        ext.theqtcompany.qt-core
        ext.theqtcompany.qt-qml
        ext.theqtcompany.qt-ui
        ext.theqtcompany.qt-cpp
        ext.ms-vscode.cmake-tools # Required for qt-cpp

        # Python
        ms-python.python

        # C/C++ dev
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        llvm-vs-code-extensions.vscode-clangd
      ];
  };

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/VSCodium/User/settings.json".source = ./settings.json;
      ".config/VSCodium/User/keybindings.json".source = ./keybindings.json;
      ".vscode-oss/argv.json".source = ./argv.json;
    };
  });
}
