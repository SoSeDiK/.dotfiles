{
  config,
  lib,
  pkgs,
  ...
}:

let
  # TODO Error if ydotool is not enabled
  autopasteScript = pkgs.writeShellScript "smile-autopaste" ''
    # Wait for DBus session socket (up to 5 seconds)
    for i in {1..50}; do
      if [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && [ -e "''${DBUS_SESSION_BUS_ADDRESS#unix:path=}" ]; then
        break
      fi
      sleep 0.1
    done

    LAST_TRIGGER=0
    DEBOUNCE_MS=500

    ${lib.getExe' pkgs.dbus "dbus-monitor"} \
      --monitor "type='signal',interface='it.mijorus.smile',member='CopiedEmojiBroadcast',path='/it/mijorus/smile/actions'" \
    | while IFS= read -r line; do
        NOW=$(date +%s%3N)  # milliseconds since epoch
        if [ $((NOW - LAST_TRIGGER)) -lt $DEBOUNCE_MS ]; then
          continue
        fi
        LAST_TRIGGER=$NOW

        # Sync clipboard -> primary selection, so paste is correct in terminals
        ${lib.getExe' pkgs.wl-clipboard "wl-paste"} | ${lib.getExe' pkgs.wl-clipboard "wl-copy"} --primary -n

        # Paste (Shift + Insert)
        ${lib.getExe' pkgs.ydotool "ydotool"} key 42:1 110:1 110:0 42:0
      done
  '';
in
{
  environment.systemPackages = with pkgs; [
    smile
  ];

  # Auto paste emoji after selecting
  systemd.user.services.smile-autopaste = {
    description = "Smile autopaste service (D-Bus trigger)";
    after = [
      "graphical-session.target"
      "dbus.service"
    ];
    serviceConfig = {
      ExecStart = autopasteScript;
      Restart = "on-failure";
      RestartSec = 2;
      Environment = "YDOTOOL_SOCKET=${config.environment.variables.YDOTOOL_SOCKET}";
    };
    wantedBy = [ "default.target" ];
  };
}
