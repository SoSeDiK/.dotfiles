{ config, pkgs, username, ... }:

{
  services.teamviewer.enable = true;

  services.ratbagd.enable = true;
  environment.systemPackages = with pkgs; [
    piper
    openrazer-daemon
    polychromatic
  ];
  users.users.${username} = {
    extraGroups = [ "games" ];
  };

  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ username ];
}
