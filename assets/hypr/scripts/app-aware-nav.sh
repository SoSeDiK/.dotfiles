#!/usr/bin/env bash

direction="$1"

# Exit if invalid argument
wl-copy "$direction"
[[ "$direction" != "right" && "$direction" != "left" ]] && exit 1

# Get the active window info
window_info=$(hyprctl activewindow -j 2>/dev/null)

# Check if there's an active window
if [[ -z "$window_info" ]] || [[ "$window_info" == "null" ]]; then
  echo "No active window found" >&2
  exit 1
fi

app_tags=$(echo "$window_info" | jq -r '.tags')

# Firefox supports this natively
if [[ "$app_tags" == *"firefox-based-browser"* ]]; then
    exit 1
fi

if [[ "$direction" == "right" ]]; then
    ydotool key 56:1 105:1 56:0 105:0 # Alt + Left
elif [[ "$direction" == "left" ]]; then
    ydotool key 56:1 106:1 56:0 106:0 # Alt + Right
fi
