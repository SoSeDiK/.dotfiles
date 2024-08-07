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

  # Don't control camera from pipewire
  # https://www.reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
  services.pipewire.wireplumber.extraConfig = {
    "disable-camera" = {
      "wireplumber.profiles" = {
        main = {
          "monitor.libcamera" = "disabled";
        };
      };
    };
  };

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
