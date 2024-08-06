{ pkgs, config, lib, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) cpuType vfioIds;
in
{
  # Configure kernel options to make sure IOMMU & KVM support is on.
  # GPU kernel modules can be switched by scripts in ./hooks
  boot = {
    kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"

      "kvm-${cpuType}"
      "amdgpu"

      # "nvidia"
      # "nvidia_modeset"
      # "nvidia_drm"
      # "nvidia_uvm"
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
    extraModprobeConfig =
      # VFIO
      "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}"
      # Nvidia
      + "options nvidia "
      + lib.concatStringsSep
        " "
        [
          # nvidia assumes that by default your CPU does not support PAT,
          # but this is effectively never the case in 2024
          "NVreg_UsePageAttributeTable=1"
          # This may be a noop, but it's somewhat uncertain
          "NVreg_EnablePCIeGen3=1"
          # This is sometimes needed for ddc/ci support, see
          # https://www.ddcutil.com/nvidia/
          "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # OpenGL
  hardware.graphics = {
    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # Configure NVIDIA-specific things
  # https://github.com/TLATER/dotfiles/blob/master/nixos-config/hosts/yui/nvidia/default.nix
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    # Power management is required to get NVIDIA GPUs to behave on
    # suspend, due to firmware bugs. Aren't NVIDIA great?
    powerManagement.enable = true;

    prime = {
      amdgpuBusId = lib.mkForce "PCI:5:0:0";
      nvidiaBusId = lib.mkForce "PCI:1:0:0";
    };
  };

  environment.variables = {
    # Required to run the correct GBM backend for NVIDIA GPUs on wayland
    # GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
