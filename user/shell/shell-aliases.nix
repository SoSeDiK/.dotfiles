{ config, pkgs, ... }:

{
  home.shellAliases = {
    runwm = "~/.dotfiles/user/shell/scripts/connect-via-looking-glass.sh";
  };
}
