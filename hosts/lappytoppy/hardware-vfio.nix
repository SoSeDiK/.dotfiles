{ lib, ... }:

let
  vfioIds = [ "10de:1f95" "10de:10fa" ]; # The IOMMU ids for GPU passthrough
in
{
  # Configure kernel options to make sure IOMMU & KVM support is on
  boot = {
    kernelModules = [
      # "kvm-amd" # Loaded by default hardware scan

      # Required for passthrough, can be loaded when needed
      # "vfio_pci"
      # "vfio"
      # "vfio_iommu_type1"

      # "amdgpu" # Loaded by nixos-hardware module
    ];
    blacklistedKernelModules = [
      # These are loaded by default due to services.xserver.enable being enabled
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];
    kernelParams = [
      # VFIO
      "iommu=pt"
      "kvm.ignore_msrs=1"
    ];
    extraModprobeConfig = lib.concatStringsSep "\n" [
      # VFIO
      "options vfio-pci ids=${lib.concatStringsSep "," vfioIds}"
    ];
  };
}
