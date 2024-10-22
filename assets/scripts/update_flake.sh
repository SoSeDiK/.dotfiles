#!/usr/bin/env bash

pushd ~/.dotfiles

command="nix flake update"

for input in "$@"; do
  command+=" $input"
done

echo "Running: $command"
$command

popd
