#!/usr/bin/env bash

# Opens link in profile instance if it's running, or in default if not

FIREFOX_BIN="firefox-nightly"

is_firefox_profile_running() {
    pgrep -f "$FIREFOX_BIN-$1" > /dev/null
}

if is_firefox_profile_running "$1"; then
    $FIREFOX_BIN -P "$1" "$2"
else
    $FIREFOX_BIN "$2"
fi
