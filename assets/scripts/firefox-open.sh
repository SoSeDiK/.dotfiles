#!/usr/bin/env bash

# Opens link in profile instance if it's running, or in default if not
# *Special case: if not running default profile but private exists, open in private
# (!) Depends on Hyprland to show special private workspace

FIREFOX_BIN="firefox-nightly"

is_firefox_profile_running() {
    pgrep -f "$FIREFOX_BIN-$1" > /dev/null
}

if [ "$1" != "default" ] && is_firefox_profile_running "$1"; then
    $FIREFOX_BIN -P "$1" "$2"
elif ! is_firefox_profile_running "default" && is_firefox_profile_running "private"; then
    $FIREFOX_BIN --private-window -P "private" "$2"
    hyprctl dispatch focusworkspaceoncurrentmonitor "special:private"
else
    $FIREFOX_BIN "$2"
fi
