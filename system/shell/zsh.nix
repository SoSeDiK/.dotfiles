{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    thefuck
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ver = "~/.dotfiles/system/shell/scripts/ver.sh";
      update = "~/.dotfiles/system/shell/scripts/update_flake.sh";
      updates = "~/.dotfiles/system/shell/scripts/update_system.sh";
      updateu = "~/.dotfiles/system/shell/scripts/update_home.sh";
      hp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/alloc_hugepages.sh";
      rhp = "sudo /var/lib/libvirt/hooks/qemu.d/win11/release/end/dealloc_hugepages.sh";
      linkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/nvidia_gpu.sh";
      unlinkgpu = "sudo ~/.dotfiles/system/apps/virtualization/hooks/vfio_gpu.sh";
      renv = "sudo systemctl restart display-manager.service";
    };
    #histSize = 10000;
    #histFile = "${config.xdg.dataHome}/zsh/history";

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # home-manager?
  # programs.direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };
}
