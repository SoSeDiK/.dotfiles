{
  pkgs,
  lib,
  homeUsers,
  flakeDir,
  ...
  }:

let
  keys = {
    UpArrow = "$terminfo[kcuu1]";
    DownArrow = "$terminfo[kcud1]";
  };
in {
  programs.zsh = {
    enable = true;
    # Disable global completion init to speed up `compinit` call in `~/.zshrc`.
    # Needs adding the compinit call to every user's ~/.zshrc
    # enableGlobalCompInit = false;
  };

  hjem.users = lib.genAttrs homeUsers (username: {
    rum.programs.zsh = {
      enable = true;
      plugins = {
        history-substring-search = {
          source = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
          config = ''
            bindkey "${keys.UpArrow}" history-substring-search-up        # Jump to the previous command in history
            bindkey "${keys.DownArrow}" history-substring-search-down    # Jump to the next command in history
          '';
        };
        completions = {
          source = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        };
        autosuggestions = {
          source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        };
        highlighting = {
          source = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        };
      };
      initConfig = ''
        eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config "${flakeDir}/assets/oh-my-posh/omp.toml")"

        # Print fancy system info
        microfetch

        # If a pattern for filename generation has no matches, print an error
        setopt nomatch

        # Beep on error in ZLE
        unsetopt beep

        # Do not treat the #, ~ and ^ characters as part of patterns for filename generation
        unsetopt extendedglob

        # Do not report the status of background jobs immediately, wait
        unsetopt notify
      '';
    };
  });
}
