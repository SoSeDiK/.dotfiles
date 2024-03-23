#!/usr/bin/env bash

# Find target window address
window_info=$(hyprctl clients -j)
window_address=$(echo "$window_info" | jq -r --arg title "$1" '.[] | select(.title == $title) | .address')

if [ -z "$window_address" ]; then
    exit
fi

# Apply alpha
hyprctl setprop address:$window_address alpha $2
hyprctl setprop address:$window_address alphainactive $3
