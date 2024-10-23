#!/usr/bin/env bash

hyprctl dispatch exit &
sleep 10
killall -9 Hyprland
