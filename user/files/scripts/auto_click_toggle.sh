#!/usr/bin/env bash

if pgrep -f auto_click.sh > /dev/null; then
    pkill -f auto_click.sh
else
    ~/.dotfiles/user/files/scripts/auto_click.sh &
fi
