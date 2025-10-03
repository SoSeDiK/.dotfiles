{
  inputs,
  ...
}:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.systemd = {
    enable = true; # enables systemd support in stage1 - required for the below setup
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];

      # LUKS/TPM process. enc is a device name.
      after = [ "systemd-cryptsetup@enc.service" ];

      # Before mounting the system root (/sysroot) during the early boot process
      before = [ "sysroot.mount" ];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the BTRFS root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/enc /mnt

        # Remove old subvolumes
        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "Deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
        echo "Restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };
}
