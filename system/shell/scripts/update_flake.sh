#!/usr/bin/env bash
pushd ~/.dotfiles
sudo nix-channel --update
sudo nix flake update
git add .
popd
