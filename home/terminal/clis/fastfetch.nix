{ pkgs, config, flakeDir, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    fastfetch
    (writeShellScriptBin "neofetch" "fastfetch") # Proxy neofetch to fastfetch
  ];

  xdg.configFile."fastfetch/config.jsonc".source = mkOutOfStoreSymlink "${flakeDir}/assets/fastfetch/config.jsonc";
}
