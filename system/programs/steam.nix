{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
