{ pkgs, ... }:

let
  # Fixup repo/file removal not working due to missing glib
  github-desktop = pkgs.github-desktop.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.glib ];
    installPhase = ''
      ${oldAttrs.installPhase}

      wrapProgram $out/bin/github-desktop \
        --set PATH "${pkgs.glib}/bin:$PATH"
    '';
  });
in
{
  # Apps
  home.packages = [
    github-desktop
  ];

  # Handle auth within the app
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
  };
}
