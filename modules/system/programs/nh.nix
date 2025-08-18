{ flakeDir, ... }:

{
  # Nix cli helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
    flake = flakeDir;
  };

  # Handled by nh
  nix.gc.automatic = false;
}
