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
        # Make sure ~/Games exists
        gamesDir=${homeDir}/Games
        mkdir -p $gamesDir
        chown -R ${username}:users $gamesDir

        # Create symlink for Steam games
        linkDir=$gamesDir/Steam
        ln -sf ${homeDir}/.local/share/Steam/steamapps/common $linkDir
        chown -R ${username}:users $linkDir
      '';
  };
}
