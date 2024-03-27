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
    local new_alpha=$(awk -v current="$current_alpha" -v incr="$increment" 'BEGIN { new_alpha = current + incr; if (new_alpha < 0) { new_alpha = 0 } else if (new_alpha > 1) { new_alpha = 1 } printf "%.2f", new_alpha }')
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
    echo "window_address,alpha,alpha_inactive" > "$csv_file"
fi

# Read the visibility from the CSV file
IFS=',' read -r window visibility visibility_inactive < <(awk -F',' -v window="$window_address" '$1 == window {print $0}' "$csv_file")

# If visibility is not found in the CSV file, set it to 1.0
if [[ -z "$visibility" ]]; then
    visibility=1.0
    visibility_inactive=1.0
fi

# Calculate new alpha values
alpha=$(calculate_alpha "$visibility" "$2")
alpha_inactive=$(calculate_alpha "$visibility_inactive" "$3")

# Update the CSV file if visibility has changed
if (( $(echo "$alpha != $visibility || $alpha_inactive != $visibility_inactive" | bc -l) )); then
    awk -v window="$window_address" -v alpha="$alpha" -v alpha_inactive="$alpha_inactive" -F',' -v OFS=',' 'BEGIN { found = 0 } $1 == window { $2 = alpha; $3 = alpha_inactive; found = 1 } { print } END { if (!found) print window, alpha, alpha_inactive }' "$csv_file" > tmpfile && mv tmpfile "$csv_file"
fi

# Apply alpha
hyprctl setprop address:$window_address alpha $alpha lock
hyprctl setprop address:$window_address alphainactive $alpha_inactive lock
