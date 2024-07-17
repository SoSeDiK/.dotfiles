{ ... }:

{
  # Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # Enable rtkit for real-time scheduling, required for pipewire
  security.rtkit.enable = true;

  # Enable low latency
  services.pipewire.extraConfig.pipewire = {
    "92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 4096;
      };
    };
  };
}
