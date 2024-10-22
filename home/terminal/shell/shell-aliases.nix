{ dotAssetsDir, ... }:

let
  flakeDir = "/home/sosedik/.dotfiles"; # TODO remove :)
in
{
  home.shellAliases = {
    "..." = "cd ../..";
    gw = "./gradlew";
    ver = "${dotAssetsDir}/scripts/ver.sh";
    reboot = "systemctl reboot";
    # Updating system
    update = "${dotAssetsDir}/scripts/update_system.sh --update";
    updates = "${dotAssetsDir}/scripts/update_system.sh";
    updatec = "${dotAssetsDir}/scripts/update_commit.sh";
    updatef = "${dotAssetsDir}/scripts/update_flake.sh";
    # Updating stuff
    gw2update = "${dotAssetsDir}/scripts/update-gw-2-stuff.sh";
    uccssupdate = "${flakeDir}/home/programs/firefox/firefox_profile/uc_css-updater.sh";
    gccleanup = "nh clean all";
    wallpaper = "${dotAssetsDir}/scripts/set-background.sh";
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
