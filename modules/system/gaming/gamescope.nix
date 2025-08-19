{ pkgs, ... }:

{
  programs.gamescope = {
    enable = true;
    capSysNice = false; # https://github.com/NixOS/nixpkgs/issues/351516
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };
}
