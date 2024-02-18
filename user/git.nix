{ config, pkgs, profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) gitUsername gitEmail; in
{
  programs.git = {
    enable = true;
    userName = gitUsername;
    userEmail = gitEmail;
  };
}
