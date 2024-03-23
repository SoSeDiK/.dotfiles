#!/usr/bin/env bash

# Find Blish HUD address
window_info=$(hyprctl clients -j)
window_address=$(echo "$window_info" | jq -r '.[] | select(.title == "Blish HUD") | .address')

if [ -z "$window_address" ]; then
    return
fi

hyprctl setprop address:$window_address alphainactive $1
