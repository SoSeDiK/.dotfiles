{ ... }:

{
  # Boot animation
  boot.plymouth.enable = true;

  # Hide boot logs (until plymouth can take over stage 1)
  boot = {
    consoleLogLevel = 0;
    loader.timeout = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      # "splash" # Added automatically by plymouth
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
  };
}
