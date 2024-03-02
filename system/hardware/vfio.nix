{ pkgs, config, lib, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) cpuType gpuType vfioIds;
in
lib.mkIf ("${gpuType}" == "amd") {
  # Configure kernel options to make sure IOMMU & KVM support is on.
  # GPU kernel modules can be switched by scripts in ./hooks
  boot = {
    kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"

      "kvm-${cpuType}"
      "amdgpu"
    ];
    kernelParams = [
      "${cpuType}_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
    ];
    extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}"; # TODO uncomment for vfio
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # OpenGL
  hardware.opengl = {
    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
}
