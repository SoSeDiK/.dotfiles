{ inputs, ... }:

{
  # Hybrid mode by default
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid
  ];

  # # Discrete NVIDIA-only
  # specialisation.nvidia.configuration = {
  #   imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-nvidia ];
  #   disabledModules = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid ];
  # };

  # # iGPU-only
  # specialisation.amd.configuration = {
  #   imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-amd ];
  #   disabledModules = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid ];
  # };

  # VFIO
  specialisation.vfio.configuration = {
    imports = [ ./hardware-vfio.nix ];
  };
}
