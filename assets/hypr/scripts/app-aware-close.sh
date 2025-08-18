ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r ".class")

if [[ $ACTIVE_WINDOW == firefox-nightly-private ]]; then
    hyprctl -q dispatch sendshortcut CTRL, q,
else
    # closes (not kills) the active window
    hyprctl dispatch killactive
fi
