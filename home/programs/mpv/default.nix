{ pkgs, ... }:

let
  mkMpvScript = path: pkgs.mpvScripts.callPackage path { };
in
{
  # Video player
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc # UI
      mpris
      thumbfast
      autoload
      memo
      (mkMpvScript ./mpvScripts/simple-undo.nix)
      (mkMpvScript ./mpvScripts/skip-to-silence.nix)
    ];
  };
}
