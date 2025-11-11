{
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    mutableExtensionsDir = true;
    profiles.default.extensions =
      let
        # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/refs/heads/master/data/cache/vscode-marketplace-latest.json
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

        # TOML
        ext.tamasfe.even-better-toml

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
}
