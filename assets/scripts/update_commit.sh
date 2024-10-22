#!/usr/bin/env bash

hostname=$(hostname)

pushd ~/.dotfiles/user/files/scripts

gen=$(nixos-rebuild --flake .#$hostname list-generations | grep current)
#git add .
git commit -am "$gen"

popd
