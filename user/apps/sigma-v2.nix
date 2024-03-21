{ appimageTools
, fetchurl
, lib
}:

let
  pname = "sigma-file-manager-v2";
  version = "2.0.0-alpha.1";
  src = fetchurl {
    url = "https://github.com/aleksey-hoffman/sigma-file-manager/releases/download/v${version}/Sigma.File.Manager.v2_${version}_amd64.AppImage";
    hash = "sha256-IFigRk3BnUTIm4107YO5mBs+fpQR6Stoo9olqRCU5rY=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Remove version from entrypoint
    mv $out/bin/sigma-file-manager-v2-"${version}" $out/bin/sigma-file-manager-v2

    # Installs .desktop files
    install -Dm444 ${appimageContents}/sigma-file-manager-v2.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/sigma-file-manager-v2.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/sigma-file-manager-v2.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=sigma-file-manager-v2'
  '';

  meta = with lib; {
    description = "An open-source, quickly evolving, modern file manager (explorer / finder) app";
    homepage = "https://github.com/aleksey-hoffman/sigma-file-manager";
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ gpl3Only lgpl21Plus llgpl21 ]; # project; ffmpeg; 7-zip
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ heisfer ];
    mainProgram = "sigma-file-manager-v2";
  };
}
