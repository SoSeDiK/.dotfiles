{
  config,
  lib,
  homeUsers,
  ...
}:

{
  hjem.users = lib.genAttrs homeUsers (username: {
    rum.programs.kitty = {
      enable = true;
      integrations = {
        fish.enable = lib.mkIf config.programs.fish.enable true;
        zsh.enable = lib.mkIf config.programs.zsh.enable true;
      };
    };
  });
}
