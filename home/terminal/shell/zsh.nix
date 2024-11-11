{ ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    initExtra = ''
      # Do menu-driven completion.
      zstyle ':completion:*' menu select

      zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"

      # Use all cores in make jobs
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi

      bindkey '^[[A' history-search-backward          # Up arrow        Search backward in history based on current input
      bindkey '^[[B' history-search-forward           # Down arrow      Search forward in history based on current input
      bindkey '^[[3~' delete-char                     # Delete key      Delete the character under the cursor
      bindkey '^[[5~' beginning-of-buffer-or-history  # Page Up         Jump to the first command in history
      bindkey '^[[6~' end-of-buffer-or-history        # Page Down       Jump to the last command in history
      bindkey '^[[1;3D' backward-word                 # Alt + Left      Move cursor one word to the left
      bindkey '^[[1;3C' forward-word                  # Alt + Right     Move cursor one word to the right
      bindkey '^[[H' beginning-of-line                # Home key        Move cursor to the beginning of the line
      bindkey '^[[F' end-of-line                      # End key         Move cursor to the end of the line

      # Print system info
      neofetch
    '';
    initExtraFirst = ''
      # Setup history
      HISTFILE=~/.zsh_history
      HISTSIZE=1000
      SAVEHIST=$HISTSIZE

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
