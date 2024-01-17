#!/usr/bin/env bash
pushd ~/.dotfiles
git add .
rm -f ~/.config/mimeapps.list
home-manager switch --flake .#user
popd
