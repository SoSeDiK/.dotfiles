{ pkgs, ... }:

let
  hotswapAgentVersion = "2.0.0";
  hotswapAgent = pkgs.fetchurl {
    url = "https://github.com/HotswapProjects/HotswapAgent/releases/download/RELEASE-${hotswapAgentVersion}/hotswap-agent-${hotswapAgentVersion}.jar";
    hash = "sha256-+RRH6MqKRXqoHlI5ySHfnPOs3vdivCfPis+vrxAF2GA=";
  };
  # jdk21 = pkgs.jetbrains.jdk.overrideAttrs (oldAttrs: {
  #   # Fails to build
  #   postBuild = ''
  #     # Add Hotswap Agent
  #     mkdir -p $out/lib/openjdk/lib/hotswap
  #     cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar
  #   '';
  # });
  baseJdk = pkgs.small.jetbrains.jdk; # TODO remove small
  jdk21 = pkgs.symlinkJoin {
    name = "jetbrains-jdk-hotswap";
    paths = [ baseJdk ];
    nativeBuildInputs = [ ];
    postBuild = ''
      # Workaround for Java to actually detect the hotswap agent (replace symlinks with real binaries)
      rm -r "$out/lib/openjdk/bin"
      rm -r "$out/lib/openjdk/conf"
      rm -r "$out/lib/openjdk/include"
      rm -r "$out/lib/openjdk/jmods"
      rm -r "$out/lib/openjdk/lib"

      # Add Hotswap Agent
      mkdir -p $out/lib/openjdk/lib/hotswap
      cp ${hotswapAgent} $out/lib/openjdk/lib/hotswap/hotswap-agent.jar

      cp -r "${baseJdk}/lib/openjdk/bin" "$out/lib/openjdk/bin"
      cp -r "${baseJdk}/lib/openjdk/conf" "$out/lib/openjdk/conf"
      cp -r "${baseJdk}/lib/openjdk/include" "$out/lib/openjdk/include"
      cp -r "${baseJdk}/lib/openjdk/jmods" "$out/lib/openjdk/jmods"
      cp -r "${baseJdk}/lib/openjdk/lib" "$out/lib/openjdk"
    '';
  };
  # jdk21 = pkgs.jetbrains.jdk;
in
{
  environment.systemPackages = [
    jdk21
  ];

  environment.sessionVariables = {
    JAVA_HOME = "${jdk21}/lib/openjdk";
  };
}
