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

      # Print fancy system info
      fastfetch

      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

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

      bindkey "$key[Up]" history-substring-search-up        # Up arrow        Jump to the previous command in history
      bindkey "$key[Down]" history-substring-search-down    # Down arrow      Jump to the next command in history
      bindkey "$key[Delete]" delete-char                    # Delete key      Delete the character under the cursor
      bindkey "$key[PageUp]" beginning-of-buffer-or-history # Page Up         Jump to the first command in history
      bindkey "$key[PageDown]" end-of-buffer-or-history     # Page Down       Jump to the last command in history
      bindkey '^[[1;3D' backward-word                       # Alt + Left      Move cursor one word to the left
      bindkey '^[[1;3C' forward-word                        # Alt + Right     Move cursor one word to the right
      bindkey "$key[Home]" beginning-of-line                # Home key        Move cursor to the beginning of the line
      bindkey "$key[End]" end-of-line                       # End key         Move cursor to the end of the line

      # zprof
    '';
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
}
