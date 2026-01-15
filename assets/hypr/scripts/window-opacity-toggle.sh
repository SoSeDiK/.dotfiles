#!/usr/bin/env bash

# Function to get the window address
get_window_address() {
    if [[ "$1" == "activewindow" ]]; then
        hyprctl activewindow -j | jq -r '.address'
    else
        hyprctl clients -j | jq -r --arg title "$1" '.[] | select(.title == $title) | .address'
    fi
}

# Function to calculate new alpha value
calculate_alpha() {
    local current_alpha="$1"
    local increment="$2"
    # Check if increment is absolute or relative
    if [[ "$increment" == *"+"* || "$increment" == *"-"* ]]; then
        local new_alpha=$(awk -v current="$current_alpha" -v incr="$increment" 'BEGIN { new_alpha = current + incr; if (new_alpha < 0) { new_alpha = 0 } else if (new_alpha > 1) { new_alpha = 1 } printf "%.2f", new_alpha }')
    else
        local new_alpha=$(awk -v incr="$increment" 'BEGIN { if (incr < 0) { new_alpha = 0 } else if (incr > 1) { new_alpha = 1 } else { new_alpha = incr } printf "%.2f", new_alpha }')
    fi
    echo "$new_alpha"
}

# Find target window address
window_address=$(get_window_address "$1")

# If window address is empty, exit
if [ -z "$window_address" ]; then
    exit
fi

# Get current opacity values from hyprctl
current_alpha=$(hyprctl getprop address:$window_address opacity)
current_alpha_inactive=$(hyprctl getprop address:$window_address opacity_inactive)
current_alpha_fullscreen=$(hyprctl getprop address:$window_address opacity_fullscreen)

# Calculate new alpha values based on input
alpha=$(calculate_alpha "$current_alpha" "$2")
alpha_inactive=""
alpha_fullscreen=""
if [ "$3" ]; then
    alpha_inactive=$(calculate_alpha "$current_alpha_inactive" "$3")
fi
if [ "$4" ]; then
    alpha_fullscreen=$(calculate_alpha "$current_alpha_fullscreen" "$4")
fi

# Update opacities if they've changed
if [ "$alpha" != "$current_alpha" ] || { [ "$alpha_inactive" ] && [ "$alpha_inactive" != "$current_alpha_inactive" ]; } || { [ "$alpha_fullscreen" ] && [ "$alpha_fullscreen" != "$current_alpha_fullscreen" ]; }; then
    hyprctl dispatch setprop address:$window_address opacity $alpha lock
    if [ "$alpha_inactive" ]; then
        hyprctl dispatch setprop address:$window_address opacity_inactive $alpha_inactive lock
    fi
    if [ "$alpha_fullscreen" ]; then
        hyprctl dispatch setprop address:$window_address opacity_fullscreen $alpha_fullscreen lock
    fi
fi
