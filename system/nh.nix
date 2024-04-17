{ profileName, ... }:

let inherit (import ../profiles/${profileName}/options.nix) flakeDir; in
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
  };

  environment.variables = {
    FLAKE = "${flakeDir}";
  };
}
