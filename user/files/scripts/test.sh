#!/usr/bin/env bash

TOGGLE=/tmp/.toggle

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    hyprctl keyword debug:damage_tracking false
    hyprctl keyword decoration:screen_shader "~/.dotfiles/user/hyprland/hypr/shaders/test.frag"
    hyprctl keyword general:cursor_inactive_timeout 1
    # hyprctl keyword general:gaps_in 0
    # hyprctl keyword general:gaps_out 0
    # hyprctl keyword general:border_size 0
    # hyprctl keyword decoration:rounding 0
    # hyprctl keyword decoration:drop_shadow false
    # hyprctl keyword decoration:blur:enabled false
else
    rm $TOGGLE
    hyprctl keyword decoration:screen_shader ""
    hyprctl keyword debug:damage_tracking true
    hyprctl keyword general:cursor_inactive_timeout 0
    # hyprctl keyword general:gaps_in 4
    # hyprctl keyword general:gaps_out "5, 10, -2, 10"
    # hyprctl keyword general:border_size 2
    # hyprctl keyword decoration:rounding 20
    # hyprctl keyword decoration:drop_shadow true
    # hyprctl keyword decoration:blur:enabled true
fi
