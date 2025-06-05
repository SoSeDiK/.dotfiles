{
  pkgs,
  config,
  dotAssetsDir,
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
      # UI / Visual
      zhuangtongfa.material-theme # One Dark Pro
      streetsidesoftware.code-spell-checker # language packs are installed manually
      esbenp.prettier-vscode
      # GitHub
      waderyan.gitblame
      # Utils
      ms-vscode.hexeditor
      signageos.signageos-vscode-sops
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
    nixfmt-rfc-style # nix formatter
  ];

  home.sessionVariables = {
    EDITOR = "codium --wait";
  };

  xdg.configFile."VSCodium/User/settings.json".source =
    mkOutOfStoreSymlink "${dotAssetsDir}/codium/settings.json";
  xdg.configFile."VSCodium/User/keybindings.json".source =
    mkOutOfStoreSymlink "${dotAssetsDir}/codium/keybindings.json";
}
