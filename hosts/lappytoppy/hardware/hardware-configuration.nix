{
  config,
  lib,
  modulesPath,
  homeUser,
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

  # Speedup rebuilds by having /tmp be a tmpfs (and reducing strain on hdd/ssd)
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  # Boot
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/65AE-2549";
    fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
  };

  # Swap
  swapDevices = [ { device = "/dev/disk/by-uuid/74eabf9c-a99d-4338-b0a4-15f313ec8d9b"; } ];

  # Root as LUKS-encrypted btrfs with subvolumes
  boot.initrd.systemd.enable = true; # For luks keyFileTimeout
  boot.initrd.luks.devices = {
    "enc" = {
      device = "/dev/disk/by-uuid/80122acf-2c71-4a08-b95d-bcac5c62d7af";
      keyFile = "/enc.lek:LABEL=JUNKYARD";
      keyFileTimeout = 10;
    };
    "swap" = {
      device = "/dev/disk/by-uuid/2bf1d33d-e835-474f-945b-d9e74f7e2b5f";
      keyFile = "/enc.lek:LABEL=JUNKYARD";
      keyFileTimeout = 10;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a30e74d4-d41c-4e22-b534-3d016e095d96";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "noatime"
      "compress=zstd:1"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/a30e74d4-d41c-4e22-b534-3d016e095d96";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "noatime"
      "compress=zstd:1"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a30e74d4-d41c-4e22-b534-3d016e095d96";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
      "compress=zstd:1"
    ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/a30e74d4-d41c-4e22-b534-3d016e095d96";
    fsType = "btrfs";
    options = [
      "subvol=persist"
      "noatime"
      "compress=zstd:1"
    ];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/a30e74d4-d41c-4e22-b534-3d016e095d96";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "noatime"
      "compress=zstd:1"
    ];
    neededForBoot = true;
  };

  # Mount data disk
  fileSystems."/home/${homeUser}/Data" = {
    device = "/dev/nvme1n1p5";
    fsType = "ext4";
    # options = [
      # "rw"
      # "uid=1000"
      # "allow_other" # allow non-root access
    # ];
  };

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
