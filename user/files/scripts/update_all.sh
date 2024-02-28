#!/usr/bin/env bash

pushd ~/.dotfiles/user/files/scripts
source ./update_flake.sh
if [ $? -ne 0 ]; then
  echo "Something went wrong updating flake."
  popd
  exit 1
fi

source ./update_system.sh --update
if [ $? -ne 0 ]; then
  echo "Something went wrong rebuilding system."
  popd
  exit 1
fi

source ./update_home.sh --update
if [ $? -ne 0 ]; then
  echo "Something went wrong rebuilding home."
  popd
  exit 1
fi

gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"

popd
