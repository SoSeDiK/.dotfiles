{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    handlr-regex # xdg-open replacement; handle URLs/files apps
    # Workaround for apps invoking desktop entry directly
    (makeDesktopItem {
      name = "handlro";
      desktopName = "handlro";
      exec = "${handlr-regex}/bin/handlr open \"%U\"";
      mimeTypes = [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      terminal = true;
      noDisplay = true;
    })
    (lib.hiPrio (writeShellScriptBin "xdg-open" "handlr open \"$@\"")) # Proxy xdg-open to handlr
    (writeShellScriptBin "xterm" "handlr launch x-scheme-handler/terminal -- \"$@\"") # Proxy xterm to handlr
  ];
}
