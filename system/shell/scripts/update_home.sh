#!/usr/bin/env bash

hostname=$(hostname)

pushd ~/.dotfiles
git add .
rm -f ~/.zshrc
rm -f ~/.config/mimeapps.list
rm -f ~/.local/share/applications/mimeapps.list
rm -f ~/.config/user-dirs.dirs
# home-manager switch --flake .#lappytoppy
if [[ "$*" == *"--update"* ]] || [[ "$*" == *"-u"* ]]; then
  nh home switch --nom --configuration "$hostname" --update
else
  nh home switch --nom --configuration "$hostname"
fi
popd
