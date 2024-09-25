{ ... }:

let
  flakeDir = "/home/sosedik/.dotfiles";
in
{
  home.shellAliases = {
    "..." = "cd ../..";
    gw = "./gradlew";
    ver = "${flakeDir}/user/files/scripts/ver.sh";
    reboot = "systemctl reboot";
    update = "${flakeDir}/user/files/scripts/update_system.sh --update";
    updates = "${flakeDir}/user/files/scripts/update_system.sh";
    updatec = "${flakeDir}/user/files/scripts/update_commit.sh";
    gw2update = "${flakeDir}/user/files/scripts/update-gw-2-stuff.sh";
    uccssupdate = "${flakeDir}/user/apps/firefox/firefox_profile/uc_css-updater.sh";
    #gccleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    gccleanup = "nh clean all";
    wallpaper = "${flakeDir}/user/files/scripts/set-background.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    linkgpu = "sudo ${flakeDir}/system/apps/virtualization/hooks/nvidia_gpu.sh";
    unlinkgpu = "sudo ${flakeDir}/system/apps/virtualization/hooks/unload_gpu.sh";
    virtlinkgpu = "sudo ${flakeDir}/system/apps/virtualization/hooks/vfio_gpu.sh";
    killhypr = "${flakeDir}/user/hyprland/hypr/scripts/exit_hypr.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "${flakeDir}/user/files/scripts/connect-via-looking-glass.sh";
    fixspotify = "rm -rf ~/.cache/spofity"; # sometimes it refuces to relaunch when it's running in bg
  };
}
