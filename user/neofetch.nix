{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    (writeShellScriptBin "neofetch" "fastfetch")
  ];

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        // "type": "small"
        "source": "nixos_small"
      },
      "display": {
        "separator": " \u001b[34m> "
      },
      // `\u001b` + code + m -> is used for color
      "modules": [
        {
          "type": "title",
          "format": "\u001b[1m\u001b[94m Crafted with Love 󱃱"
        },
        {
          "type": "custom",
          "format": "\u001b[37m──────────────────────"
        },
        {
          "key": " OS      ",
          "keyColor": "blue",
          "type": "os",
          "format": "{3} {12}"
        },
        {
          "key": " Kernel  ",
          "keyColor": "white",
          "type": "kernel"
        },
        {
          "key": " Packages",
          "keyColor": "blue",
          "type": "packages"
        },
        {
          "key": "󰅐 Uptime  ",
          "keyColor": "green",
          "type": "uptime"
        },
        {
          "key": " DE      ",
          "keyColor": "light_blue",
          "type": "wm"
        },
        {
          "key": "󰌢 Machine ",
          "keyColor": "red",
          "type": "host",
          "format": "{3}"
        },
        {
          "key": "󰍹 Display ",
          "keyColor": "magenta",
          "type": "display",
          "compactType": "original-with-refresh-rate"
        },
        {
          "key": " CPU     ",
          "keyColor": "yellow",
          "type": "cpu"
        },
        {
          "key": " GPU     ",
          "keyColor": "white",
          "type": "gpu"
        },
        {
          "key": " Memory  ",
          "keyColor": "magenta",
          "type": "memory"
        },
        "break",
        {
          "type": "custom",
          "format": "\u001b[90m \u001b[31m \u001b[32m \u001b[33m \u001b[34m \u001b[35m \u001b[36m \u001b[37m \u001b[38m \u001b[39m "
        }
      ]
    }
  '';

  # xdg.configFile."neofetch/config.conf".text = ''
  #   print_info() {
  #       prin "$(color 6)  Made with Love  "
  #       info underline
  #       info "$(color 7)  VER" kernel
  #       info "$(color 2)  UP " uptime
  #       info "$(color 4)  PKG" packages
  #       info "$(color 6)  DE " de
  #       info "$(color 5)  TER" term
  #       info "$(color 3)  CPU" cpu
  #       info "$(color 7)  GPU" gpu
  #       info "$(color 5)  MEM" memory
  #       prin " "
  #       prin "$(color 1) $(color 2) $(color 3) $(color 4) $(color 5) $(color 6) $(color 7) $(color 8)"
  #   }
  #   distro_shorthand="on"
  #   memory_unit="gib"
  #   cpu_temp="C"
  #   separator=" $(color 4)>"
  #   stdout="off"
  # '';
}
