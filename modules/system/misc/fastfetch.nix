{
  lib,
  pkgs,
  flakeDir,
  homeUsers,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    (writeShellScriptBin "neofetch" "fastfetch") # Proxy neofetch to fastfetch
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/fastfetch/config.jsonc".source = "${flakeDir}/assets/fastfetch/config.jsonc";
    };
  });
}
