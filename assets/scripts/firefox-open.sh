#!/usr/bin/env bash

# Opens link in profile instance if it's running, or in default if not
# *Special case: if not running default profile but private exists, open in private
# (!) Depends on Hyprland to show special private workspace

bins_to_try=("firefox" "firefox-nightly" "zen" "zen-twilight")
default_bin=${FIREFOX_BIN:-zen-twilight}

is_profile_running() {
    pgrep -f "$1-$2" > /dev/null
}

for bin in "${bins_to_try[@]}"; do
    if [ "$1" != "default" ] && is_profile_running "$bin" "$1"; then
        $bin -P "$1" "$2"
        exit 0
    elif ! is_profile_running "$bin" "default" && is_profile_running "$bin" "private"; then
        $bin --private-window -P "private" "$2"
        hyprctl dispatch focusworkspaceoncurrentmonitor "special:private"
        exit 0
    fi
done

$default_bin "$2"
