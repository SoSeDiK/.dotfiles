{ self', ... }:

let
  # Fixup repo/file removal not working due to missing glib
  # github-desktop = pkgs.github-desktop.overrideAttrs (oldAttrs: {
  #   buildInputs = oldAttrs.buildInputs ++ [
  #     pkgs.glib
  #     pkgs.xdg-utils
  #   ];
  #   installPhase = ''
  #     ${oldAttrs.installPhase}

  #     wrapProgram $out/bin/github-desktop \
  #       --set PATH "${pkgs.glib}/bin:$PATH"
  #   '';
  # });
  github-desktop-plus = self'.packages.github-desktop-plus;
in
{
  # Apps
  home.packages = [
    github-desktop-plus
  ];

  # Handle auth within the app
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop-plus.desktop";
  };
}
