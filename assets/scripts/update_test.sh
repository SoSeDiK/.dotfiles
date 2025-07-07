#!/usr/bin/env bash

set -e
pushd ~/.dotfiles

git add .

echo "Rebuilding NixOS System… (test mode)"

# Remove old generation home-manager files
rm -f ~/.zshrc.hmbackup
rm -f ~/.config/mimeapps.list.hmbackup
rm -f ~/.local/share/applications/mimeapps.list.hmbackup
rm -f ~/.config/handlr/handlr.toml.hmbackup
rm -f ~/.config/cava/config.hmbackup
rm -f ~/.config/user-dirs.dirs.hmbackup
rm -f ~/.config/fastfetch/config.jsonc.hmbackup
rm -f ~/.mozilla/firefox/profiles.ini.hmbackup

# Rebuild without adding a boot entry
nixos-rebuild --sudo test --flake .#$(hostname) --show-trace

popd
