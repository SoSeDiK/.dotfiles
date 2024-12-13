#!/usr/bin/env sh

playerctl=$(playerctl -a status 2>/dev/null)

if grep "Playing" <<< "$playerctl" >/dev/null; then
    playerctl -p "spotify,*" metadata --format "󰎆  {{title}} - {{artist}}" 2>/dev/null ||
    playerctl metadata --format "󰎆  {{title}} - {{artist}}"
fi
