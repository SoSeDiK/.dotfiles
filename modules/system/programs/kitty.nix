{
  config,
  lib,
  self,
  homeUsers,
  ...
}:

{
  hjem.users = lib.genAttrs homeUsers (username: {
    rum.programs.kitty = {
      enable = true;
      integrations = {
        fish.enable = lib.mkIf config.hjem.users.${username}.rum.programs.fish.enable true;
        zsh.enable = lib.mkIf config.hjem.users.${username}.rum.programs.zsh.enable true;
      };
      settings."" = builtins.readFile "${self}/assets/kitty/kitty.conf" + "\n# Generated";
    };
  });
}
