#!/usr/bin/env bash

hostname=$(hostname)

pushd ~/.dotfiles

git pull

gen=$(nixos-rebuild --flake .#$hostname list-generations | grep 'True')
git add .
git commit -am "$gen"

popd
