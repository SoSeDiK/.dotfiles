{ ... }:

{
  programs.kitty.enable = true;

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/terminal" = "kitty.desktop";
  };

  home.sessionVariables = {
    TERM = "kitty";
  };
}
