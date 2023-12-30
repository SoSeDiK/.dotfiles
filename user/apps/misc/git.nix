{ config, pkgs, name, email, ... }:

{
  home.packages = with pkgs; [
    git
  ];

  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
  };
}
