{ inputs, ... }:

{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # Run software via , (comma) without installing it
  programs.nix-index-database.comma.enable = true;

  programs.command-not-found.enable = false;
}
