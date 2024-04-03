{ config, lib, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) steam homeDir username; in
lib.mkIf (steam == true) {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Create symlink for Steam games
  # I don't know a better way...
  systemd.services.libvirtd = {
    preStart =
      ''
        gamesDir=${homeDir}/Games
        linkDir=$gamesDir/Steam

        if [ -L "$linkDir" ]; then
            exit 0
        fi

        mkdir -p $gamesDir
        chown -R ${username}:users $gamesDir

        ln -sf ${homeDir}/.local/share/Steam/steamapps/common $linkDir
        chown -R ${username}:users $linkDir
      '';
  };
}
