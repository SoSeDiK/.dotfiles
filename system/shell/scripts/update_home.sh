#!/usr/bin/env bash
cd ~/.dotfiles
git add .
rm ~/.config/mimeapps.list
home-manager switch --flake .#user
