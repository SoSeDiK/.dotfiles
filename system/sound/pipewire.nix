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
    "10-disable-camera" = {
      "wireplumber.profiles" = {
        main."monitor.libcamera" = "disabled";
      };
    };
  };

  # Enable low latency
  services.pipewire.extraConfig.pipewire = {
    "92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 4096;
      };
    };
  };
  services.pipewire.extraConfig.pipewire-pulse = {
    "92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = { };
        }
      ];
      "pulse.properties" = {
        "pulse.default.req" = "1024/48000";
        "pulse.min.req" = "1024/48000";
        "pulse.max.req" = "4096/48000";
        "pulse.min.quantum" = "1024/48000";
        "pulse.max.quantum" = "4096/48000";
      };
      "stream.properties" = {
        "node.latency" = "1024/48000";
        "resample.quality" = 1;
      };
    };
  };
}
