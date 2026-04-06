# Things done manually on fresh install

- Restore /persist data (e.g., age key for sops)
- Import GPG keys from ~/.gnupg/keys (gpg --import ~/.gnupg/keys/KEYFILE)
- Logins: Steam, Discord, Spotify, Stremio, GitHub Desktop
- Blush HUD options

# Missing things
- 

# Tracked issues (- issue \* workaround/note)

- handlr terminal emulator support does not work
  - kitty "-e" "handlr" "open" "https://google.com"
  - Context: https://github.com/Anomalocaridid/handlr-regex?tab=readme-ov-file#terminal-emulator-compatibility

- https://github.com/Alexays/Waybar/issues/1127
  # Wine system tray integration
  - Using plasma-workspace's xembed-sni-proxy;
  - https://gitlab.winehq.org/wine/wine/-/merge_requests/2808
- https://github.com/microsoft/vscode/issues/187338
  # VSCode fails identifying gnome-keyring
  - Manually forcing it to use "gnome-libsecret" as password store
- https://github.com/virt-manager/virt-manager/issues/156
  # virt-manager does not support easy folder sharing
  - Using samba server that auto starts & closes during VM workflow
- zsh does not like combining emoji
  - https://github.com/zsh-users/zsh-autosuggestions/issues/570

# Why home-manager?
- Firefox profiles
- VS Code mutable extensions
- stylix is neat
- Useful options (mangohud, sni proxy, etc.)
