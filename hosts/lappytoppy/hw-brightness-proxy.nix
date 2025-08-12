{ pkgs, ... }:

# Sync nvidia and amd backlight changes
let
  # May vary on different setups
  nvidiaDeviceId = "nvidia_0";
  amdDeviceId = "amdgpu_bl1";
  nvidia_max_brightness = 100;
  amdgpu_max_brightness = 65535;
  nvidiaPath = "/sys/class/backlight/${nvidiaDeviceId}/brightness";
  amdPath = "/sys/class/backlight/${amdDeviceId}/brightness";
in
{
  systemd = {
    services =
      let
        syncBacklight =
          {
            sourcePath,
            targetPath,
            sourceMaxBrightness,
            targetMaxBrightness,
            serviceName,
            description,
          }:
          {
            description = description;
            wantedBy = [ "multi-user.target" ];
            unitConfig = {
              ConditionPathExists = [
                sourcePath
                targetPath
              ];
              Conflicts = [ "backlight-monitor-${serviceName}.service" ];
            };
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.writeShellScript serviceName ''
                if [ ! -f "${sourcePath}" ] || [ ! -f "${targetPath}" ]; then
                    exit 0
                fi

                source_brightness=$(cat "${sourcePath}")
                target_brightness=$(cat "${targetPath}")

                source_percentage=$((source_brightness * 100 / ${toString sourceMaxBrightness}))
                target_percentage=$((target_brightness * 100 / ${toString targetMaxBrightness}))
                if [ "$source_percentage" -eq "$target_percentage" ]; then
                    exit 0
                fi

                scaled_brightness=$((source_brightness * ${toString targetMaxBrightness} / ${toString sourceMaxBrightness}))
                if [ "$scaled_brightness" -ne "$target_brightness" ]; then
                    echo "$scaled_brightness" > ${targetPath}
                fi
              ''}";
            };
          };
      in
      {
        backlight-monitor-nvidia-to-amd = syncBacklight {
          sourcePath = nvidiaPath;
          targetPath = amdPath;
          sourceMaxBrightness = nvidia_max_brightness;
          targetMaxBrightness = amdgpu_max_brightness;
          serviceName = "backlight-monitor-nvidia-to-amd";
          description = "Sync nvidia backlight changes to amd";
        };
        backlight-monitor-amd-to-nvidia = syncBacklight {
          sourcePath = amdPath;
          targetPath = nvidiaPath;
          sourceMaxBrightness = amdgpu_max_brightness;
          targetMaxBrightness = nvidia_max_brightness;
          serviceName = "backlight-monitor-amd-to-nvidia";
          description = "Sync amd backlight changes to nvidia";
        };
      };
    paths = {
      backlight-monitor-nvidia-to-amd = {
        description = "Monitor nvidia backlight changes";
        wantedBy = [ "multi-user.target" ];
        pathConfig = {
          PathModified = nvidiaPath;
        };
      };
      backlight-monitor-amd-to-nvidia = {
        description = "Monitor amd backlight changes";
        wantedBy = [ "multi-user.target" ];
        pathConfig = {
          PathModified = amdPath;
        };
      };
    };
  };
}
