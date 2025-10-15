#!/usr/bin/env bash

# Opens link in profile instance if it's running, or in default if not
# *Special case: if not running default profile but private exists, open in private
# (!) Depends on Hyprland to show special private workspace

BROWSER_BIN=${FIREFOX_BIN:-firefox-nightly}

is_profile_running() {
    pgrep -f "$BROWSER_BIN-$1" > /dev/null
}

if [ "$1" != "default" ] && is_profile_running "$1"; then
    $BROWSER_BIN -P "$1" "$2"
elif ! is_profile_running "default" && is_profile_running "private"; then
    $BROWSER_BIN --private-window -P "private" "$2"
    hyprctl dispatch focusworkspaceoncurrentmonitor "special:private"
else
    $BROWSER_BIN "$2"
fi
