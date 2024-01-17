{ config, pkgs, ... }:

let
  shellAliases = {
    "..." = "cd ../..";
    ver = "~/.dotfiles/system/shell/scripts/ver.sh";
    update = "~/.dotfiles/system/shell/scripts/update_flake.sh";
    updates = "~/.dotfiles/system/shell/scripts/update_system.sh";
    updateu = "~/.dotfiles/system/shell/scripts/update_home.sh";
    updatea = "~/.dotfiles/system/shell/scripts/update_all.sh";
    wallpaper = "~/.dotfiles/user/shell/scripts/set-background.sh";
    hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
    rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
    linkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/nvidia_gpu.sh";
    unlinkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/vfio_gpu.sh";
    killhypr = "~/.dotfiles/user/wm/hyprland/hypr/scripts/exit_hypr.sh";
    renv = "sudo systemctl restart display-manager.service";
  };
in {
  environment.systemPackages = with pkgs; [
    thefuck
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    #histSize = 10000;
    #histFile = "${config.xdg.dataHome}/zsh/history";

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  # For some reason "home.shellAliases" doesn't work
  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
  programs.fish.shellAliases = shellAliases;

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # home-manager?
  # programs.direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };
}
