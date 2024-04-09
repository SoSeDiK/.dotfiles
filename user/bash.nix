{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bash-completion
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      source ~/.nix-profile/share/bash-completion/bash_completion
      neofetch
      if [ -f $HOME/.bashrc-personal ]; then
        source $HOME/.bashrc-personal
      fi
    '';
  };
}
