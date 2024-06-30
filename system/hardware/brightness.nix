{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  boot = {
    kernelParams = [
      "amdgpu.backlight=0"
    ];
  };
}
