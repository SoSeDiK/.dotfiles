#!/usr/bin/env bash

# Configuration via environment variables
FLOATING_WIDTH="80%"
FLOATING_HEIGHT="80%"

# Get the active window info
window_info=$(hyprctl activewindow -j 2>/dev/null)

# Check if there's an active window
if [[ -z "$window_info" ]] || [[ "$window_info" == "null" ]]; then
  echo "No active window found" >&2
  exit 1
fi

# Get current floating state
is_floating=$(echo "$window_info" | jq -r '.floating')

hyprctl dispatch togglefloating

if [[ "$is_floating" != "true" ]]; then
  # Resize and center the window
  hyprctl dispatch resizeactive exact "$FLOATING_WIDTH" "$FLOATING_HEIGHT"
  hyprctl dispatch centerwindow
fi
