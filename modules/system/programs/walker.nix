{
  lib,
  inputs,
  inputs',
  flakeDir,
  hostName,
  homeUsers,
  ...
}:

{
  imports = [
    inputs.walker.nixosModules.default
  ];

  hjem.users = lib.genAttrs homeUsers (username: {
    files = {
      ".config/walker/walker.conf".source = "${flakeDir}/hosts/${hostName}/assets/walker/walker.conf";
    };
  });

  programs.walker = {
    enable = true;
    package = inputs'.walker.packages.default;
    runAsService = true;
  };

  nix.settings = {
    substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };
}
