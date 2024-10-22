#!/usr/bin/env bash
# Test IDs: 859663165 2985464274 2931446135

assets_dir=~/Data/SteamLibrary/steamapps/common/wallpaper_engine/assets
workshop_dir=~/Data/SteamLibrary/steamapps/workshop/content/431960
screenshot_dest=~/.cache/wallpaper_dump.png

# Check if the first argument is provided
if [ -n "$1" ]; then
    # Check if the argument is a link
    if [[ "$1" =~ ^https://steamcommunity.com/sharedfiles/filedetails/\?id=([0-9]+) ]]; then
        # Extract numbers from the link
        background_id="${BASH_REMATCH[1]}"
    else
        background_id=$1
    fi
    echo "Using provided wallpaper: $background_id"
else
    # Default background
    echo "No argument provided, using default wallpaper"
    background_id=2985464274
fi

# Kill old running instance
pkill -f linux-wallpaperengine

linux-wallpaperengine --no-audio-processing --assets-dir $assets_dir --screenshot $screenshot_dest $workshop_dir/$background_id --screen-root eDP-1 &
