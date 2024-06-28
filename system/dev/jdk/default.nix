{ pkgs, ... }:

let
  hotswapAgentVersion = "1.4.2-SNAPSHOT";
  hotswapAgent = pkgs.fetchurl {
    url = "https://github.com/HotswapProjects/HotswapAgent/releases/download/${hotswapAgentVersion}/hotswap-agent-${hotswapAgentVersion}.jar";
    hash = "sha256-Mzi5T9yZoHNosKK6J6E+ExEqsq7B/frK8HyzKlXaYpA=";
  };
  # jdk21 = pkgs.jetbrains.jdk.overrideAttrs (oldAttrs: {
  #   # Fails to build
  #   postBuild = ''
  #     # Add Hotswap Agent
  #     mkdir -p $out/lib/openjdk/lib/hotswap
  #     cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar
  #   '';
  # });
  # jdk21 = pkgs.symlinkJoin {
  #   name = "jetbrains-jdk-hotswap";
  #   paths = [ pkgs.jetbrains.jdk ];
  #   nativeBuildInputs = [ ];
  #   postBuild = ''
  #     # Workaround for Java to actually detect the hotswap agent (replace symlinks with real binaries)
  #     rm -r "$out/lib/openjdk/bin"
  #     rm -r "$out/lib/openjdk/conf"
  #     rm -r "$out/lib/openjdk/include"
  #     rm -r "$out/lib/openjdk/jmods"
  #     rm -r "$out/lib/openjdk/lib"

  #     # Add Hotswap Agent
  #     mkdir -p $out/lib/openjdk/lib/hotswap
  #     cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar

  #     cp -r "${pkgs.jetbrains.jdk}/lib/openjdk/bin" "$out/lib/openjdk/bin"
  #     cp -r "${pkgs.jetbrains.jdk}/lib/openjdk/conf" "$out/lib/openjdk/conf"
  #     cp -r "${pkgs.jetbrains.jdk}/lib/openjdk/include" "$out/lib/openjdk/include"
  #     cp -r "${pkgs.jetbrains.jdk}/lib/openjdk/jmods" "$out/lib/openjdk/jmods"
  #     cp -r "${pkgs.jetbrains.jdk}/lib/openjdk/lib" "$out/lib/openjdk"
  #   '';
  # };
  jdk21 = pkgs.jetbrains.jdk;
in
{
  # Profile-specific apps
  environment.systemPackages = [
    jdk21
  ];

  environment.sessionVariables = {
    JAVA_HOME = "${jdk21}/lib/openjdk";
  };
}
