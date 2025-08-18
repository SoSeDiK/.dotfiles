{
  lib,
  pkgs,
  flakeDir,
  hostName,
  homeUsers,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    walker # App/task launcher
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/walker/walker.conf".source = "${flakeDir}/hosts/${hostName}/assets/walker/walker.conf";
    };
  });
}
