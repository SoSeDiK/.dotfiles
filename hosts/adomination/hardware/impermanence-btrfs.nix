{
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir -p /mnt

    # We first mount the BTRFS root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/disk/by-uuid/b8f5b73d-4d3f-410d-b650-897062a6ef1 /mnt

    # Remove old subvolumes
    btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "Deleting /$subvolume subvolume..."
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
}
