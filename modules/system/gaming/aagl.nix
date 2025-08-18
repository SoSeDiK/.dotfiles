{ inputs, ... }:

{
  imports = [
    # Hoyo game launchers
    inputs.aagl.nixosModules.default
  ];

  # Add binary cache
  nix.settings = inputs.aagl.nixConfig;
}
