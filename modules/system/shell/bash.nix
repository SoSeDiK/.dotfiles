{
  lib,
  pkgs,
  flakeDir,
  ...
}:

{
  programs.bash = {
    shellInit = ''
        eval "$(${lib.getExe pkgs.oh-my-posh} init bash --config "${flakeDir}/assets/oh-my-posh/omp.toml")"

        # Print fancy system info
        microfetch
    '';
    interactiveShellInit = ''
      if test -n "$KITTY_INSTALLATION_DIR"; then
          export KITTY_SHELL_INTEGRATION="enabled"
          source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
      fi

      fastfetch
    '';
  };
}
