{
  inputs,
  ...
}:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # Data to persist
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      # Network settings (e.g., Wi-Fi passwords)
      "/etc/NetworkManager/system-connections"
      # Lectured users
      "/var/db/sudo"
      # Secure boot keys
      "/var/lib/sbctl"
      # Bluetooth data
      "/var/lib/bluetooth"
      # RF Kill switch states
      "/var/lib/systemd/rfkill"
      # Important NixOS thingies
      "/var/lib/nixos"
      # Core dumbs, in case of crashes
      "/var/lib/systemd/coredump"
      # Last user & last session
      "/var/cache/tuigreet"
      # Syncthing data
      "/var/lib/syncthing"
      # Tailscale data
      "/var/lib/tailscale"
    ];

    files = [
      # Unique device id
      "/etc/machine-id"
    ];
  };

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
    };
  };
}
