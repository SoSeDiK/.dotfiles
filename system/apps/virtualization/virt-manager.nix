{ config, lib, pkgs, username, ... }:
let
  # System's CPU (either "amd" or "intel")
  platform = "amd";
  # The IOMMU ids for GPU passthrough
  vfioIds = [ "10de:1f95" "10de:10fa" ];
  # Path to hooks
  # hooksPath = "/home/${username}/.dotfiles/system/apps/virtualization/hooks";
in
{
  environment.systemPackages = with pkgs; [
    swtpm
    OVMFFull
    looking-glass-client
    freerdp
  ];

  # Configure kernel options to make sure IOMMU & KVM support is on.
  # GPU kernel modules can be switched by scripts in ./hooks
  boot = {
    kernelModules = [
      # "vfio_pci"
      # "vfio"
      # "vfio_iommu_type1"

      "kvm-${platform}"
      "amdgpu"

      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];
    kernelParams = [
      "${platform}_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
    ];
    # extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}"; # TODO uncomment for vfio
  };

  # NVIDIA settings
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  # https://github.com/TLATER/dotfiles/blob/master/nixos-config/yui/nvidia
  hardware.nvidia = {
    # The current stable nvidia driver is utterly broken. Use
    # production for now to work around stuff like this:
    # https://forums.developer.nvidia.com/t/535-86-05-low-framerate-vulkan-apps-stutter-under-wayland-xwayland/26147
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    # Power management is required to get nvidia GPUs to behave on
    # suspend, due to firmware bugs. Aren't nvidia great?
    powerManagement.enable = true;
    open = true;
  };
  boot.extraModprobeConfig =
    "options nvidia "
    + lib.concatStringsSep " " [
      # nvidia assume that by default your CPU does not support PAT,
      # but this is effectively never the case in 2023
      "NVreg_UsePageAttributeTable=1"
      # This may be a noop, but it's somewhat uncertain
      "NVreg_EnablePCIeGen3=1"
      # This is sometimes needed for ddc/ci support, see
      # https://www.ddcutil.com/nvidia/
      #
      # Current monitor does not support it, but this is useful for
      # the future
      "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
      # When (if!) I get another nvidia GPU, check for resizeable bar
      # settings
    ];
  environment.variables = {
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on nvidia
    WLR_NO_HARDWARE_CURSORS = "1";
    # See https://github.com/elFarto/nvidia-vaapi-driver#configuration
    NVD_BACKEND = "direct";
  };
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
          ./wlroots-nvidia.patch
          ./wlroots-screenshare.patch
        ];
      });
    })
  ];
  # NVIDIA END

  # Add a file for looking-glass to use later. This will allow for viewing the guest VM's screen in a
  # performant way.
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${username} qemu-libvirtd -"
  ];

  programs.virt-manager.enable = true;

  # Enable virtualisation programs. These will be used by virt-manager to run your VM.
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    qemu = {
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      swtpm.enable = true;
      #runAsRoot = false;
    };
    # TODO figure out how this works
    # hooks.qemu = {
    #   hugepages_handler = "${hooksPath}/alloc_hugepages.sh";
    # };
  };

  # Copy patched GPU ROM
  systemd.services.libvirtd = {
    preStart =
      ''
        mkdir -p /var/lib/libvirt/vgabios
        ln -sf /home/${username}/.dotfiles/patched.rom /var/lib/libvirt/vgabios/patched.rom

        # Workaround "missing" modules.alias
        ln -sf /run/booted-system/kernel-modules/lib/modules /lib
      '';
  };

  hardware.opengl.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Workaround missing secure boot EFI options
  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  users.users.${username}.extraGroups = [ "kvm" "libvirtd" "qemu-libvirtd" ];
}
