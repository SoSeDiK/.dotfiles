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
    # Updating system
    ## Update flakes and rebuild
    update = "${dotAssetsDir}/scripts/update_system.sh --update";
    ## Rebuild the system
    updates = "${dotAssetsDir}/scripts/update_system.sh";
    ## Commit all changes to .dotfiles
    updatec = "${dotAssetsDir}/scripts/update_commit.sh";
    # Update flake inputs (accepts arguments for specific inputs)
    updatef = "${dotAssetsDir}/scripts/update_flake.sh";
    ## Update system without creating a boo entry
    updatet = "${dotAssetsDir}/scripts/update_test.sh";
    ## Make current configuration the one bootable by default
    updateb = "sudo /run/current-system/bin/switch-to-configuration boot";
    # Updating stuff
    gw2update = "${dotAssetsDir}/scripts/update-gw-2-stuff.sh";
    uccssupdate = "${dotAssetsDir}/firefox/uc_css-updater.sh";
    # Managing system
    kys = "shutdown now";
    reboot = "systemctl reboot";
    gccleanup = "nh clean all";
    linkgpu = "sudo ${dotAssetsDir}/vfio/nvidia_gpu.sh";
    unlinkgpu = "sudo ${dotAssetsDir}/vfio/unload_gpu.sh";
    virtlinkgpu = "sudo ${dotAssetsDir}/vfio/vfio_gpu.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    winwm = "xfreerdp -grab-keyboard /v:192.168.100.252 /u:SoSeDiK /p:PASSWORD /size:100% /d: /dynamic-resolution /audio-mode:1 /gfx-h264:avc444 +gfx-progressive +auto-reconnect /auto-reconnect-max-retries:20";
    # Shortcuts
    wallpaper = "${dotAssetsDir}/scripts/set-background.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "${dotAssetsDir}/scripts/connect-via-looking-glass.sh";
    fixspotify = "rm -rf ~/.cache/spofity"; # sometimes it refuses to relaunch when it's running in bg
  };
}
