{ config, lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) steam homeDir username; in
lib.mkIf (steam == true) {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # I don't know a better way...
  systemd.services.libvirtd = {
    preStart =
      ''
        gamesDir=${homeDir}/Games
        linkDir=$gamesDir/Steam
        mkdir -p $gamesDir
        ln -sf ${homeDir}/.local/share/Steam/steamapps/common $linkDir
        chown -R ${username}:users $linkDir
      '';
  };
}
