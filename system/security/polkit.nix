{ pkgs, ... }:

{
  security.polkit.enable = true;

  systemd.user.services.polkit-pantheon-authentication-agent-1 = {
    description = "Pantheon PolicyKit agent";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };

    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  # Automatically grant some permissions
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (
        subject.isInGroup("users") &&
        [
          "org.freedesktop.login1.reboot",
          "org.freedesktop.login1.reboot-multiple-sessions",
          "org.freedesktop.login1.power-off",
          "org.freedesktop.login1.power-off-multiple-sessions",
        ].indexOf(action.id) !== -1
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
