#!/usr/bin/env bash

set -e
pushd ~/.dotfiles

git diff -U0 *.nix
git add .

echo "Rebuilding NixOS System…"

# The usual way
# sudo nixos-rebuild switch --flake .#lappytoppy --show-trace &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Fancy nh way
if [[ "$*" == *"--update"* ]] || [[ "$*" == *"-u"* ]]; then
  nh os switch --nom --update
else
  nh os switch --nom
fi

popd
