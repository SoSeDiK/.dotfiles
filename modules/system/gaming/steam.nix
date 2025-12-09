{
  config,
  lib,
  pkgs,
  homeUsers,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    steamtinkerlaunch # Expose cli command
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      steamtinkerlaunch
    ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;

  # Create symlink for Steam games
  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      "Games/Steam".source = "${
        config.hjem.users.${username}.directory
      }/.local/share/Steam/steamapps/common";
    };
  });
}
