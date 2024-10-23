#!/usr/bin/env bash

TOGGLE=/tmp/.toggle

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    hyprctl keyword debug:damage_tracking false
    hyprctl keyword decoration:screen_shader "~/.dotfiles/assets/hypr/shaders/test.frag"
    hyprctl keyword general:cursor_inactive_timeout 1
else
    rm $TOGGLE
    hyprctl keyword decoration:screen_shader ""
    hyprctl keyword debug:damage_tracking true
    hyprctl keyword general:cursor_inactive_timeout 0
fi
