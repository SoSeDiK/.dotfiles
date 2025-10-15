#!/usr/bin/env bash

set -e
pushd ~/.dotfiles

git add .

echo "Rebuilding NixOS System…"

# Remove old generation home-manager files
rm -f ~/.zshrc.hmbackup
rm -f ~/.config/mimeapps.list.hmbackup
rm -f ~/.local/share/applications/mimeapps.list.hmbackup
rm -f ~/.config/handlr/handlr.toml.hmbackup
rm -f ~/.config/cava/config.hmbackup
rm -f ~/.config/user-dirs.dirs.hmbackup
rm -f ~/.config/fastfetch/config.jsonc.hmbackup
rm -f ~/.mozilla/firefox/profiles.ini.hmbackup

# The usual way
# nixos-rebuild --sudo switch --flake .#$(hostname) --show-trace

# Fancy nh way
case "$1" in
  --update|-u)
    nh os switch --update -- --show-trace
    ;;
  --boot|-b)
    nh os boot -- --show-trace
    ;;
  *)
    nh os switch -- --show-trace
    ;;
esac

popd
