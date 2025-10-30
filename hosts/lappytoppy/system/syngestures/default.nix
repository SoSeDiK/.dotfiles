{
  lib,
  self',
  homeUsers,
  ...
}:

{
  environment.systemPackages = [
    self'.packages.syngestures
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/syngestures.d/trackpad.toml".source = ./trackpad.toml;
    };
  });
}
