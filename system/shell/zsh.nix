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
      updates = "sudo nixos-rebuild switch --flake .#system";
      updateu = "home-manager switch --flake .#user";
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
