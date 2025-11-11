{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # enableGlobalCompInit = false;
    shellInit = ''
      # zmodload zsh/zprof
    '';
    interactiveShellInit = ''
      if test -n "$KITTY_INSTALLATION_DIR"; then
        export KITTY_SHELL_INTEGRATION="no-rc enabled"
        autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
        kitty-integration
        unfunction kitty-integration
      fi

      fastfetch

      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      # zprof
    '';
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
}
