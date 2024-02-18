{ config, pkgs, ... }:

{
  home.shellAliases = {
    "..." = "cd ../..";
    ver = "~/.dotfiles/user/files/scripts/ver.sh";
    reboot = "systemctl reboot";
    update = "~/.dotfiles/user/files/scripts/update_flake.sh";
    updates = "~/.dotfiles/user/files/scripts/update_system.sh";
    updateu = "~/.dotfiles/user/files/scripts/update_home.sh";
    updatea = "~/.dotfiles/user/files/scripts/update_all.sh";
    gccleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    wallpaper = "~/.dotfiles/user/files/scripts/set-background.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    linkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/nvidia_gpu.sh";
    unlinkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/vfio_gpu.sh";
    killhypr = "~/.dotfiles/user/hyprland/hypr/scripts/exit_hypr.sh";
    renv = "sudo systemctl restart display-manager.service";
    runwm = "~/.dotfiles/user/files/scripts/connect-via-looking-glass.sh";
    neofetch = "fastfetch";
  };
}
