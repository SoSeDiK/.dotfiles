{ flakeDir, ... }:

{
  home.shellAliases = {
    # Updating stuff
    gw2update = "${flakeDir}/assets/scripts/update-gw-2-stuff.sh";
    uccssupdate = "${flakeDir}/assets/firefox/uc_css-updater.sh";
    # Managing system
    linkgpu = "sudo ${flakeDir}/assets/vfio/nvidia_gpu.sh";
    unlinkgpu = "sudo ${flakeDir}/assets/vfio/unload_gpu.sh";
    virtlinkgpu = "sudo ${flakeDir}/assets/vfio/vfio_gpu.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    winwm = "xfreerdp -grab-keyboard /v:192.168.100.252 /u:SoSeDiK /p:PASSWORD /size:100% /d: /dynamic-resolution /audio-mode:1 /gfx-h264:avc444 +gfx-progressive +auto-reconnect /auto-reconnect-max-retries:20";
    # Shortcuts
    wallpaper = "${flakeDir}/assets/scripts/set-background.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "${flakeDir}/assets/scripts/connect-via-looking-glass.sh";
  };
}
