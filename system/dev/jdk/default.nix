{ pkgs, ... }:

let
  hotswapAgentVersion = "1.4.2-SNAPSHOT";
  hotswapAgent = pkgs.fetchurl {
    url = "https://github.com/HotswapProjects/HotswapAgent/releases/download/${hotswapAgentVersion}/hotswap-agent-${hotswapAgentVersion}.jar";
    hash = "sha256-Mzi5T9yZoHNosKK6J6E+ExEqsq7B/frK8HyzKlXaYpA=";
  };
  # jdk21 = pkgs.jetbrains.jdk;
  # jdk21 = pkgs.jetbrains.jdk.overrideAttrs (oldAttrs: {
  #   postInstall = (oldAttrs.postInstall or "") + ''
  #     # Add Hotswap Agent
  #     mkdir -p $out/lib/openjdk/lib/hotswap
  #     cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar
  #   '';
  # });
  jdk21 = pkgs.symlinkJoin {
    name = "jetbrains-jdk-hotswap";
    paths = [ pkgs.jetbrains.jdk ];
    nativeBuildInputs = [ ];
    postBuild = ''
      # Add Hotswap Agent
      mkdir -p $out/lib/openjdk/lib/hotswap
      cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar
    '';
  };
in
{
  # Profile-specific apps
  environment.systemPackages = [
    jdk21
  ];

  environment.sessionVariables = {
    # JAVA_HOME = "${jdk21.home}"; # TODO
  };
}
