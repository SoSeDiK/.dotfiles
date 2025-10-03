{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    # Enables non-free firmware on devices not recognized by `nixos-generate-config`.
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "ext4" # For USB with decryption key
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
  ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/68095231-5349-46ca-8f3d-4d4b022ffb21";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "noatime"
      "compress=zstd:1"
    ];
  };

  boot.initrd.systemd.enable = true; # For luks keyFileTimeout
  boot.initrd.luks.devices = {
    "enc" = {
      device = "/dev/disk/by-uuid/d0e18351-ed7c-481a-acba-eb927fa56077";
      keyFile = "/enc.lek:LABEL=JUNKYARD";
      keyFileTimeout = 5;
    };
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/68095231-5349-46ca-8f3d-4d4b022ffb21";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "noatime"
      "compress=zstd:1"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/68095231-5349-46ca-8f3d-4d4b022ffb21";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "compress=zstd:1"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/68095231-5349-46ca-8f3d-4d4b022ffb21";
    fsType = "btrfs";
    options = [
      "subvol=persist"
      "noatime"
      "compress=zstd:1"
    ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/68095231-5349-46ca-8f3d-4d4b022ffb21";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "noatime"
      "compress=zstd:1"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/03F3-3022";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/06f5d670-0551-48be-87d0-8cf307759e75"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
