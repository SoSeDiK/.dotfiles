{ lib, homeUsers, ... }:

{
  programs.gamemode.enable = true;

  # https://github.com/FeralInteractive/gamemode/issues/452
  users.users = lib.genAttrs homeUsers (username: {
    extraGroups = [ "gamemode" ];
  });
}
