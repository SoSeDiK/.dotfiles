{ pkgs, lib, inputs, ... }:

{
  # Hybrid mode by default
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid
  ];

  # # Discrete NVIDIA-only
  # specialisation.nvidia.configuration = {
  #   imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-nvidia ];
  #   disabledModules = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid ];
  # };

  # # iGPU-only
  # specialisation.amd.configuration = {
  #   imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-amd ];
  #   disabledModules = [ inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05-hybrid ];
  # };

  # # VFIO
  # specialisation.vfio.configuration = {
  #   imports = [ ./hardware-vfio.nix ];
  # };

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # https://bbs.archlinux.org/viewtopic.php?id=294113&p=2
  # https://wiki.archlinux.org/title/PRIME#NVIDIA
  boot.extraModprobeConfig = lib.concatStringsSep "\n" [
    ("options nvidia " + lib.concatStringsSep " " [
      # Disable GSP firmware to un-break RTD3
      "NVreg_EnableGpuFirmware=0"
      # Enable S0ix-based power management
      "NVreg_EnableS0ixPowerManagement=1"
      # Disables clearing system memory allocation before using it for the GPU
      # Potentially improves performance, but at the cost of increased security risks
      "NVreg_InitializeSystemMemoryAllocations=0"
    ])
  ];
  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/640
  # https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472

  # services.udev.extraRules = ''
  #   # Enable runtime PM for NVIDIA VGA/3D controller devices on adding device
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
  # '';

  hardware.nvidia.nvidiaPersistenced = true;
  # hardware.nvidia.modesetting.enable = false;

  # Prevent apps from holding NVIDIA GPU
  environment.variables = {
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers.outPath}/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };

  # Vulkan support for AMD
  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };
}
