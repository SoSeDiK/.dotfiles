#!/usr/bin/env bash
pushd ~/.dotfiles
git add .
sudo nixos-rebuild switch --flake .#system
popd
