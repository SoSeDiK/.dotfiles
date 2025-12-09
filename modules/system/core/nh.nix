{ pkgs, flakeDir, ... }:

{
  # Nix cli helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
    flake = flakeDir;
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "evaltime";
      text = ''
        # Use the current host if one isn't given
        HOST="''${1:-$(hostname)}"
        time nix eval \
          "$NH_FLAKE"#nixosConfigurations."$HOST".config.system.build.toplevel \
          --substituters " " \
          --option eval-cache false \
          --raw --read-only
      '';
    })
  ];

  # Handled by nh
  nix.gc.automatic = false;
}
