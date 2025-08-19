{ ... }:

{
  # https://github.com/ValveSoftware/gamescope/issues/1825
  programs.gamescope = {
    enable = true;
    capSysNice = true; # https://github.com/NixOS/nixpkgs/issues/351516
  };
}
