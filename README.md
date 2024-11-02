List of things to do:

https://github.com/Zerodya/hyprfreeze

- Chore

  - ags
    - Per-monitor workspaces
  - Theming!

- Browsing

  - Better Firefox vertical tabs layout
  - Find a way to make per-workspace bookmarks and pinned tabs
    - Different profiles maybe?
  - Declarative extensions

- Usability

  - GUI Wi-Fi (or, well, Network) manager

- System

  - Simple wallpaper picker
    - Could bump some into rofi?

- Misc

  - Lenovo not saving options due to read-only system
  - Telegram not playing some animations while in extra workspace?
    - Seems to be "fixed" by disabling power-saving mode in Telegram
  - Exiting app (e.g. via tray -> close) that is placed in extra workspace makes the extra workspace show up and block the view
  - Applying themes on the fly
    - nwg-look?

- Maybes

  - Symlink /etc/nixos to ~/.dotfiles ?

  - https://github.com/JustTemmie/steam-presence
    - Displaying custom apps in Vesktop

# Tracked issues (- issue \* workaround/note)

- https://github.com/hyprwm/Hyprland/issues/3558
  # Hyprland hangs on exit
  - Using exit_hypr script to kill Hyprland
- https://github.com/hyprwm/Hyprland/issues/4375
  # Switching workspace does not close special workspace
  - Using workspace_aware_switch script
- https://gitlab.gnome.org/GNOME/file-roller/-/issues/4
  # Archive manager doesn't support drag & drop
  - Waiting...
- https://github.com/hyprwm/Hyprland/issues/2319
  # Clipboard isn't synced with Steam/WINE apps
  - Using xclip & script: wl-paste -t text -w sh -c 'v=$(cat); cmp -s <(xclip -selection clipboard -o) <<< "$v" || xclip -selection clipboard <<< "$v"'
- https://github.com/Alexays/Waybar/issues/1127
  # Wine system tray integration
  - Using plasma-workspace's xembed-sni-proxy;
- https://github.com/microsoft/vscode/issues/187338
  # VSCode fails identifying gnome-keyring
  - Manually forcing it to use "gnome-libsecret" as password store
- https://github.com/virt-manager/virt-manager/issues/156
  # virt-manager does not support easy folder sharing
  - Using samba server that auto starts & closes during VM workflow
- https://github.com/flatpak/xdg-desktop-portal-gtk/issues/440
  # xdg-desktop-portal-gtk is unable to open links in default browser
  - DefaultEnvironment workaround: https://github.com/flatpak/xdg-desktop-portal-gtk/issues/440#issuecomment-1900520919
- https://github.com/nix-community/home-manager/issues/2562
  # zsh auto completions do not work for home-manager apps
  - Manually importing auto completions path
