{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jdk21
  ];

  environment.etc = with pkgs; {
      "jdks/jdk21".source = jdk21;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };
}
