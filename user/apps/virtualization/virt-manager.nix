{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # TODO
    #     libvirt
    #     virt-manager
    #     qemu
    #     qemu_kvm
    #     uefi-run
    #     lxc
    # swtpm
    # OVMFFull

    #     # Filesystems
    #     dosfstools
  ];

  #   home.file.".config/libvirt/qemu.conf".text = ''
  # nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  #   '';
}
