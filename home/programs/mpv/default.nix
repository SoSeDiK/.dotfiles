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
      evafast
      (mkMpvScript ./mpvScripts/simple-undo.nix)
      (mkMpvScript ./mpvScripts/skip-to-silence.nix) # F3 to skip to silence
      (mkMpvScript ./mpvScripts/fuzzydir.nix)
    ];
    config = {
      audio-file-auto = "fuzzy";
      audio-file-paths = "**"; # Relies on fuzzydir
      sub-auto = "fuzzy";
      sub-file-paths = "**"; # Relies on fuzzydir
    };
    scriptOpts = {
      thumbfast = {
        network = true;
        hwdec = true;
      };
    };
  };
}
