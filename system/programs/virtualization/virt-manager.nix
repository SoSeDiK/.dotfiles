{ config, pkgs, ... }:

let
  # Path to hooks
  # hooksPath = "${dotAssetsDir}/vfio";
  username = "sosedik";
  flakeDir = "/home/sosedik/.dotfiles";
in
{
  environment.systemPackages = with pkgs; [
    swtpm
    looking-glass-client
    freerdp
    virtiofsd
    samba # used to share a folder to VM | \\10.0.2.4\qemu
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
      # While I do not need the full QEMU (only smbd from non-default), it would require compiling it manually
      # package = pkgs.qemu_full; # pkgs.qemu.override { smbdSupport = true; };
      package = pkgs.qemu.override { smbdSupport = true; };
      ovmf.enable = true;
      ovmf.packages = [
        (pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd
      ];
      swtpm.enable = true;
      verbatimConfig = ''
        security_default_confied = 0
        seccomp_sandbox = 0
        security_driver = "none"
      '';
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
        ln -sf ${flakeDir}/patched.rom /var/lib/libvirt/vgabios/patched.rom

        # Workaround "missing" modules.alias
        ln -sf /run/booted-system/kernel-modules/lib/modules /lib
      '';
  };

  hardware.graphics.enable = true;
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
