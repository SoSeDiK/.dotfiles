#!/usr/bin/env bash
pushd ~/.dotfiles/system/shell/scripts
source ./update_flake.sh
source ./update_system.sh
source ./update_home.sh
popd
