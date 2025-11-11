#!/usr/bin/env bash

set -e
pushd ~/.dotfiles/assets/_theming

# Check if theme name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <theme_name> or $0 --themes"
    exit 1
fi

THEME_ID="$1"
THEME_PATH="./themes/${THEME_ID}"

# Check if theme folder exists
if [ ! -d "$THEME_PATH" ]; then
    echo "Error: Theme ${THEME_ID} not found"
    exit 1
fi

# kitty
file_to_cp="$THEME_PATH/kitty.conf"
if [ -f "$file_to_cp" ]; then
    cp -f "$file_to_cp" "$HOME/.config/kitty/current-theme.conf"
    pkill -SIGUSR1 kitty
fi

notify-send "   Applied theme $THEME_ID"
