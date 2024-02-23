{ config, pkgs, profileName, ... }:

let
  inherit (import ../profiles/${profileName}/options.nix) flakeDir;
in
{
  home.shellAliases = {
    "..." = "cd ../..";
    ver = "${flakeDir}/user/files/scripts/ver.sh";
    reboot = "systemctl reboot";
    update = "${flakeDir}/user/files/scripts/update_flake.sh";
    updates = "${flakeDir}/user/files/scripts/update_system.sh";
    updateu = "${flakeDir}/user/files/scripts/update_home.sh";
    updatea = "${flakeDir}/user/files/scripts/update_all.sh";
    gccleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    wallpaper = "${flakeDir}/user/files/scripts/set-background.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    linkgpu = "sudo ${flakeDir}/system/apps/virtualization/hooks/nvidia_gpu.sh";
    unlinkgpu = "sudo ${flakeDir}/system/apps/virtualization/hooks/vfio_gpu.sh";
    killhypr = "${flakeDir}/user/hyprland/hypr/scripts/exit_hypr.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "${flakeDir}/user/files/scripts/connect-via-looking-glass.sh";
  };
}
