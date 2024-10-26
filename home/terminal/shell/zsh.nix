{ ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    initExtra = ''
      zstyle ":completion:*" menu select
      zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"

      # Use all cores in make jobs
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi

      bindkey '^[[3~' delete-char                     # Key Del
      bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
      bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
      bindkey '^[[1;3D' backward-word                 # Key Alt + Left
      bindkey '^[[1;3C' forward-word                  # Key Alt + Right
      bindkey '^[[H' beginning-of-line                # Key Home
      bindkey '^[[F' end-of-line                      # Key End

      neofetch
    '';
    initExtraFirst = ''
      HISTFILE=~/.zsh_history
      HISTSIZE=1000
      SAVEHIST=1000

      # If a pattern for filename generation has no matches, print an error
      setopt nomatch

      # Beep on error in ZLE
      unsetopt beep

      # Do not treat the #, ~ and ^ characters as part of patterns for filename generation
      unsetopt extendedglob

      # Do not report the status of background jobs immediately, wait2
      unsetopt notify
    '';
  };
}
