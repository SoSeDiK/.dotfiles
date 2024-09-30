{ pkgs, config, lib, ... }:

let
  cpuType = "amd"; # System's CPU (either "amd" or "intel")
  vfioIds = [ "10de:1f95" "10de:10fa" ]; # The IOMMU ids for GPU passthrough
in
{
  # Configure kernel options to make sure IOMMU & KVM support is on.
  # GPU kernel modules can be switched by scripts in ./hooks
  boot = {
    kernelModules = [
      # "vfio_pci"
      # "vfio"
      # "vfio_iommu_type1"

      "kvm-${cpuType}"
      "amdgpu"

      # "nvidia"
      # "nvidia_modeset"
      # "nvidia_drm"
      # "nvidia_uvm"
    ];
    blacklistedKernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];
    kernelParams = [
      # VFIO
      "${cpuType}_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      # Nvidia
      "nvidia-drm.fbdev=1"
      # Extras
      "acpi_backlight=native" # let integrated gpu control the backlight
    ];
    extraModprobeConfig = lib.concatStringsSep "\n" [
      # VFIO
      "options vfio-pci ids=${lib.concatStringsSep "," vfioIds}"
      # Nvidia
      ("options nvidia " + lib.concatStringsSep " " [
        # nvidia assumes that by default your CPU does not support PAT,
        # but this is effectively never the case in 2024
        "NVreg_UsePageAttributeTable=1"
        # This may be a noop, but it's somewhat uncertain
        "NVreg_EnablePCIeGen3=1"
        # This is sometimes needed for ddc/ci support, see
        # https://www.ddcutil.com/nvidia/
        "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
      ])
    ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # OpenGL
  hardware.graphics = {
    # amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # Configure NVIDIA-specific things
  # https://github.com/TLATER/dotfiles/blob/master/nixos-config/hosts/yui/nvidia/default.nix
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    # Power management is required to get NVIDIA GPUs to behave on
    # suspend, due to firmware bugs. Aren't NVIDIA great?
    powerManagement.enable = true;
  };

  environment.variables = {
    # Required to run the correct GBM backend for NVIDIA GPUs on wayland
    # GBM_BACKEND = "nvidia-drm";
  };
}
