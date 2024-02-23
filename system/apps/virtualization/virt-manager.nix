{ config, lib, pkgs, username, ... }:
let
  # Path to hooks
  # hooksPath = "/home/${username}/.dotfiles/system/apps/virtualization/hooks";
in
{
  environment.systemPackages = with pkgs; [
    swtpm
    OVMFFull
    looking-glass-client
    freerdp
    virtiofsd
  ];

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
