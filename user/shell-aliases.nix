{ config, pkgs, ... }:

let
  shellAliases = {
    "..." = "cd ../..";
    ver = "~/.dotfiles/system/shell/scripts/ver.sh";
    reboot = "systemctl reboot";
    update = "~/.dotfiles/system/shell/scripts/update_flake.sh";
    updates = "~/.dotfiles/system/shell/scripts/update_system.sh";
    updateu = "~/.dotfiles/system/shell/scripts/update_home.sh";
    updatea = "~/.dotfiles/system/shell/scripts/update_all.sh";
    gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    wallpaper = "~/.dotfiles/user/shell/scripts/set-background.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    linkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/nvidia_gpu.sh";
    unlinkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/vfio_gpu.sh";
    killhypr = "~/.dotfiles/user/wm/hyprland/hypr/scripts/exit_hypr.sh";
    renv = "sudo systemctl restart display-manager.service";
    neofetch = "fastfetch";
  };
in
{
  # For some reason "home.shellAliases" doesn't work
  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
  programs.fish.shellAliases = shellAliases;
}
