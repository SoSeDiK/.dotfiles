#!/usr/bin/env bash

hostname=$(hostname)

set -e
pushd ~/.dotfiles

git diff -U0 *.nix
git add .

# Remove old generation files
rm -f ~/.zshrc
rm -f ~/.config/mimeapps.list
rm -f ~/.local/share/applications/mimeapps.list
rm -f ~/.config/user-dirs.dirs

echo "Rebuilding Home Manager…"

# The usual way
# home-manager switch --flake .#lappytoppy --show-trace &>hm-switch.log || (cat hm-switch.log | grep --color error && false)

# Fancy nh way
if [[ "$*" == *"--update"* ]] || [[ "$*" == *"-u"* ]]; then
  nh home switch --configuration "$hostname" --update
else
  nh home switch --configuration "$hostname"
fi

popd
