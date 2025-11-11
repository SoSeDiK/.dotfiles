app_tags=$(hyprctl activewindow -j | jq -r ".tags")

if [[ "$app_tags" == *"firefox-based-browser"* ]]; then
    hyprctl -q dispatch sendshortcut CTRL, q,
else
    # closes (not kills) the active window
    hyprctl dispatch killactive
fi
