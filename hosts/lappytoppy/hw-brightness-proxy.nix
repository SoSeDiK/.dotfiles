{ pkgs, ... }:

# Sync nvidia backlight changes to amd
let
  # May vary on different setups
  nvidiaDeviceId = "nvidia_0";
  amdDeviceId = "amdgpu_bl1";
  nvidia_max_brightness = 100;
  amdgpu_max_brightness = 255;
in
{
  systemd = {
    services.backlight-monitor = {
      description = "Sync nvidia backlight changes to amd";
      wantedBy = [ "multi-user.target" ];
      # unitConfig = {
      #   ConditionPathExists = [
      #     "/sys/class/backlight/${nvidiaDeviceId}/actual_brightness"
      #     "/sys/class/backlight/${amdDeviceId}/actual_brightness"
      #   ];
      # };
      serviceConfig = {
        # Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "backlight-monitor" ''
          nvidia_path=/sys/class/backlight/${nvidiaDeviceId}/actual_brightness
          if [ ! -f "$nvidia_path" ]; then
            return 0
          fi
          nvidia_brightness=$(cat $nvidia_path)
          scaled_brightness=$(expr $(expr $nvidia_brightness \* ${toString amdgpu_max_brightness}) / ${toString nvidia_max_brightness})
          echo "$scaled_brightness" > /sys/class/backlight/${amdDeviceId}/brightness
        ''}";
      };
    };
    paths.backlight-monitor = {
      description = "Monitor nvidia backlight changes";
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathModified = "/sys/class/backlight/${nvidiaDeviceId}/brightness";
      };
    };
  };
}
