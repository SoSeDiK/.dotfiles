{ ... }:

{
  # GUI Bluetooth Manager
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # Enable D-Bus experimental interfaces
        Experimental = "true";
      };
    };
  };
}
