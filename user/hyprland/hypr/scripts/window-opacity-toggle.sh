#!/usr/bin/env bash

# Define the path to the CSV file storage
csv_file="/tmp/window_visibility_cache.csv"

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

# Check if the CSV file exists, if not, create it with headers
if [[ ! -f "$csv_file" ]]; then
    echo "window_address,alpha,alpha_inactive,alpha_fullscreen" > "$csv_file"
fi

# Read the visibility from the CSV file
IFS=',' read -r window visibility visibility_inactive visibility_fullscreen < <(awk -F',' -v window="$window_address" '$1 == window {print $0}' "$csv_file")

# If visibility is not found in the CSV file, set it to 1.0
if [[ -z "$visibility" ]]; then
    visibility=1.0
fi
if [[ -z "$visibility_inactive" ]]; then
    visibility_inactive=1.0
fi
if [[ -z "$visibility_fullscreen" ]]; then
    visibility_fullscreen=1.0
fi

# Calculate new alpha values
alpha=$(calculate_alpha "$visibility" "$2")
alpha_inactive=""
alpha_fullscreen=""
if [ "$3" ]; then
    alpha_inactive=$(calculate_alpha "$visibility_inactive" "$3")
fi
if [ "$4" ]; then
    alpha_fullscreen=$(calculate_alpha "$visibility_fullscreen" "$4")
fi

echo $alpha_inactive " | " $visibility_inactive

# Update the CSV file if visibility has changed
if [ "$alpha" != "$visibility" ] || { [ "$alpha_inactive" ] && [ "$alpha_inactive" != "$visibility_inactive" ]; } || { [ "$alpha_fullscreen" ] && [ "$alpha_fullscreen" != "$visibility_fullscreen" ]; }; then
    new_alpha=$alpha
    new_alpha_inactive=$visibility_inactive
    new_alpha_fullscreen=$visibility_fullscreen
    if [ "$alpha_inactive" ]; then
        new_alpha_inactive=$alpha_inactive
    fi
    echo $new_alpha_inactive
    if [ "$alpha_fullscreen" ]; then
        new_alpha_fullscreen=$alpha_fullscreen
    fi
    awk -v window="$window_address" -v alpha="$new_alpha" -v alpha_inactive="$new_alpha_inactive" -v alpha_fullscreen="$new_alpha_fullscreen" -F',' -v OFS=',' 'BEGIN { found = 0 } $1 == window { $2 = alpha; $3 = alpha_inactive; $4 = alpha_fullscreen; found = 1 } { print } END { if (!found) print window, alpha, alpha_inactive, alpha_fullscreen }' "$csv_file" > tmpfile && mv tmpfile "$csv_file"
fi

# Apply alpha
hyprctl setprop address:$window_address alpha $alpha lock
if [ "$alpha_inactive" ]; then
    hyprctl setprop address:$window_address alphainactive $alpha_inactive lock
fi
if [ "$alpha_fullscreen" ]; then
    hyprctl setprop address:$window_address alphafullscreen $alpha_fullscreen lock
fi
