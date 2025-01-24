{ dotAssetsDir, ... }:

{
  home.shellAliases = {
    # Moving around
    ".." = "cd ..";
    "..." = "cd ../..";
    c = "clear";
    cc = "cd ~ && clear";
    # Helpers
    gw = "./gradlew";
    ver = "${dotAssetsDir}/scripts/ver.sh";
    reboot = "systemctl reboot";
    # Updating system
    update = "${dotAssetsDir}/scripts/update_system.sh --update";
    updates = "${dotAssetsDir}/scripts/update_system.sh";
    updatec = "${dotAssetsDir}/scripts/update_commit.sh";
    updatef = "${dotAssetsDir}/scripts/update_flake.sh";
    updatet = "${dotAssetsDir}/scripts/update_test.sh";
    # Updating stuff
    gw2update = "${dotAssetsDir}/scripts/update-gw-2-stuff.sh";
    uccssupdate = "${dotAssetsDir}/firefox/uc_css-updater.sh";
    # Managing system
    kys = "shutdown now";
    gccleanup = "nh clean all";
    linkgpu = "sudo ${dotAssetsDir}/vfio/nvidia_gpu.sh";
    unlinkgpu = "sudo ${dotAssetsDir}/vfio/unload_gpu.sh";
    virtlinkgpu = "sudo ${dotAssetsDir}/vfio/vfio_gpu.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    winwm = "xfreerdp -grab-keyboard /v:192.168.100.252 /u:SoSeDiK /p:PASSWORD /size:100% /d: /dynamic-resolution /audio-mode:1 /gfx-h264:avc444 +gfx-progressive +auto-reconnect /auto-reconnect-max-retries:20";
    # Shortcups
    wallpaper = "${dotAssetsDir}/scripts/set-background.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "${dotAssetsDir}/scripts/connect-via-looking-glass.sh";
    fixspotify = "rm -rf ~/.cache/spofity"; # sometimes it refuces to relaunch when it's running in bg
  };
}
