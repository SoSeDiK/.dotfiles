{ inputs, config, pkgs, ... }:

let
  jdk21 = pkgs.callPackage ./jetbrains-jdk-21-hotswap.nix { };
in
{
  # Profile-specific apps
  environment.systemPackages = [
    jdk21
  ];

  environment.sessionVariables = {
    JAVA_HOME = "${jdk21.home}";
  };
}
