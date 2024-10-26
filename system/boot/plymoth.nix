{ ... }:

{
  # Boot animation
  boot.plymouth.enable = true;

  # Hide boot logs (until plymouth can take over stage 1)
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      # "splash" # Added automatically by plymouth
    ];
  };
}
