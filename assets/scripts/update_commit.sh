#!/usr/bin/env bash

hostname=$(hostname)

pushd ~/.dotfiles/assets/scripts

gen=$(nixos-rebuild --flake .#$hostname list-generations | grep current)
#git add .
git commit -am "$gen"

popd
