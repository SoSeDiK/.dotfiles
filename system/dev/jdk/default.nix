{ inputs, pkgs, ... }:

let
  hotswapAgentVersion = "1.4.2-SNAPSHOT";
  hotswapAgent = pkgs.fetchurl {
    url = "https://github.com/HotswapProjects/HotswapAgent/releases/download/${hotswapAgentVersion}/hotswap-agent-${hotswapAgentVersion}.jar";
    hash = "sha256-Mzi5T9yZoHNosKK6J6E+ExEqsq7B/frK8HyzKlXaYpA=";
  };
  # jdk21 = inputs.jetbrains.packages.${pkgs.system}.jetbrains.jdk;
  jdk21 = inputs.jetbrains.packages.${pkgs.system}.jetbrains.jdk.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      # Add Hotswap Agent
      mkdir -p $out/lib/openjdk/lib/hotswap
      cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar
    '';
  });
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
