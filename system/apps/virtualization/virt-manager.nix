{ config, pkgs, username, ... }:
let
  # System's CPU (either "amd" or "intel").
  platform = "amd";
  # The IOMMU ids for GPU passthrough.
  vfioIds = [ "10de:1f95" "10de:10fa" ];
  # Path to hooks
  hooksPath = "/home/${username}/.dotfiles/system/apps/virtualization/hooks";
in {
  environment.systemPackages = with pkgs; [
    swtpm
    OVMFFull
    looking-glass-client
    freerdp
  ];



  # <vcpu placement="static">6</vcpu>
  # <cputune>
  #   <vcpupin vcpu="0" cpuset="6"/>
  #   <vcpupin vcpu="1" cpuset="7"/>
  #   <vcpupin vcpu="2" cpuset="8"/>
  #   <vcpupin vcpu="3" cpuset="9"/>
  #   <vcpupin vcpu="4" cpuset="10"/>
  #   <vcpupin vcpu="5" cpuset="11"/>
  # </cputune>


    # <input type="evdev">
    #   <source dev="/dev/input/by-id/usb-Razer_Orochi_V2_000000000000-event-mouse"/>
    # </input>

  # Configure kernel options to make sure IOMMU & KVM support is on.
  boot = {
    kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"

      "kvm-${platform}"
      "amdgpu"

      #"nvidia"
      #"nvidia_modeset"
      #"nvidia_uvm"
      #"nvidia_drm"
    ];
    kernelParams = [
      "${platform}_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "mousepoll=48" # 125Hz; games lag with high poll rate, and passing USB mouse is worse :/
    ];
    extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," vfioIds}";
  };

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
    # hooks.qemu = {
    #   hugepages_handler = "${hooksPath}/alloc_hugepages.sh";
    # };
  };

  systemd.services.libvirtd = {
    preStart =
    ''
      mkdir -p /var/lib/libvirt/vgabios
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end
      
      ln -sf /home/${username}/.dotfiles/patched.rom /var/lib/libvirt/vgabios/patched.rom
      ln -sf ${hooksPath}/alloc_hugepages.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh
      ln -sf ${hooksPath}/dealloc_hugepages.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh

      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh
      chmod +x /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh
    '';
  };

  hardware.opengl.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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
