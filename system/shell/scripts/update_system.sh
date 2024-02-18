#!/usr/bin/env bash

pushd ~/.dotfiles
git add .
# sudo nixos-rebuild switch --flake .#lappytoppy
if [[ "$*" == *"--update"* ]] || [[ "$*" == *"-u"* ]]; then
  nh os switch --nom --update
else
  nh os switch --nom
fi
popd
