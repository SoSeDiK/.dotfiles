{
  lib,
  pkgs,
  ...
}:

let
  # Script for auto-paste support in smile
  autopasteScript = pkgs.writeShellScript "smile-autopaste" ''
    # Consume all input to avoid broken pipe
    cat > /dev/null
    exec ${lib.getExe' pkgs.ydotool "ydotool"} key Shift+Insert
  '';
in
{
  environment.systemPackages = with pkgs; [
    smile
  ];

  # User service – activated by the socket
  systemd.user.services.smile-autopaste = {
    description = "Smile autopaste service";
    serviceConfig = {
      ExecStart = autopasteScript;
      Type = "simple";
      # The socket is passed as stdin (fd 0) by systemd
    };
  };

  # Socket unit – triggers the service on every connection
  systemd.user.sockets.smile-autopaste = {
    description = "Socket for Smile autopaste service";
    socketConfig = {
      # Path to the Unix socket. %t expands to XDG_RUNTIME_DIR (/run/user/UID).
      ListenStream = "%t/smile-autopaste.sock";
      Accept = true; # one service instance per connection
    };
    wantedBy = [ "sockets.target" ];
  };
}
