#!/usr/bin/env bash
cd ~/.dotfiles
sudo nix-channel --update
sudo nix flake update
git add .
