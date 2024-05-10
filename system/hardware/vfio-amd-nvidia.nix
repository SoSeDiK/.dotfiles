{ pkgs, config, lib, profileName, ... }:

let
  inherit (import ../../profiles/${profileName}/options.nix) cpuType vfioIds;
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

      "nvidia"
      # "nvidia_modeset"
      "nvidia_drm modeset=0"
      "nvidia_uvm"
    ];
    kernelParams = [
      "${cpuType}_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
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
          # Preserve video memory after suspend
          "NVreg_PreserveVideoMemoryAllocations=1"
        ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # OpenGL
  hardware.opengl = {
    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

  # Configure NVIDIA-specific things
  # https://github.com/TLATER/dotfiles/blob/master/nixos-config/yui/nvidia
  hardware.nvidia = {
    # Prefer production nvidia driver
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    # Power management is required to get NVIDIA GPUs to behave on
    # suspend, due to firmware bugs. Aren't NVIDIA great?
    powerManagement.enable = true;
    # Enable open source NVIDIA kernel module
    # TODO: actually, disable for now: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472
    open = false;
  };

  environment.variables = {
    # Required to run the correct GBM backend for NVIDIA GPUs on wayland
    GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # See https://github.com/elFarto/nvidia-vaapi-driver#configuration
    NVD_BACKEND = "direct";
  };

  # Note: comment and patches from https://github.com/TLATER/dotfiles/blob/master/nixos-config/yui/nvidia
  # Replace a glFlush() with a glFinish() - this prevents stuttering
  # and glitching in all kinds of circumstances for the moment.
  #
  # Apparently I'm waiting for "explicit sync" support, which needs to
  # land as a wayland thing. I've seen this work reasonably with VRR
  # before, but emacs continued to stutter, so for now this is
  # staying.
  nixpkgs.overlays = [
    (_: final: {
      wlroots_0_16 = final.wlroots_0_16.overrideAttrs (_: {
        patches = [
          ./patches/wlroots-nvidia.patch
          ./patches/wlroots-screenshare.patch
        ];
      });
    })
  ];
}
