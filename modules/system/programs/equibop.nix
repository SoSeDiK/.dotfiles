{
  pkgs,
  lib,
  flakeDir,
  homeUsers,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    equibop
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/equibop/settings/settings.json".source = "${flakeDir}/assets/equibop/settings.json";
    };
  });
}
