#!/usr/bin/env bash
pushd ~/.dotfiles
git add .
rm -f ~/.zshrc
rm -f ~/.config/mimeapps.list
rm -f ~/.config/user-dirs.dirs
home-manager switch --flake .#user
popd
