#!/usr/bin/env bash

SPECIAL=`hyprctl monitors -j | jq .[0][\"specialWorkspace\"][\"name\"]`

SPECIAL=${SPECIAL//\"/}

[ $SPECIAL ] && hyprctl dispatch togglespecialworkspace ${SPECIAL:8}

hyprctl dispatch split:workspace $1
