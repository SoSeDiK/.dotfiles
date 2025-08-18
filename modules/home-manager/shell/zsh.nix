{ lib, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    initContent = lib.mkBefore ''
      # Print system info
      neofetch

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

      # Do not report the status of background jobs immediately, wait
      unsetopt notify

      # Key codes
      key=(
        BackSpace  "$terminfo[kbs]"
        Home       "$terminfo[khome]"
        End        "$terminfo[kend]"
        Insert     "$terminfo[kich1]"
        Delete     "$terminfo[kdch1]"
        Up         "$terminfo[kcuu1]"
        Down       "$terminfo[kcud1]"
        Left       "$terminfo[kcub1]"
        Right      "$terminfo[kcuf1]"
        PageUp     "$terminfo[kpp]"
        PageDown   "$terminfo[knp]"
      )

      # Use all cores in make jobs
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi

      bindkey "$key[Up]" history-substring-search-up        # Up arrow        Jump to the previous command in history
      bindkey "$key[Down]" history-substring-search-down    # Down arrow      Jump to the next command in history
      bindkey "$key[Delete]" delete-char                    # Delete key      Delete the character under the cursor
      bindkey "$key[PageUp]" beginning-of-buffer-or-history # Page Up         Jump to the first command in history
      bindkey "$key[PageDown]" end-of-buffer-or-history     # Page Down       Jump to the last command in history
      bindkey '^[[1;3D' backward-word                       # Alt + Left      Move cursor one word to the left
      bindkey '^[[1;3C' forward-word                        # Alt + Right     Move cursor one word to the right
      bindkey "$key[Home]" beginning-of-line                # Home key        Move cursor to the beginning of the line
      bindkey "$key[End]" end-of-line                       # End key         Move cursor to the end of the line
    '';
  };
}
