#!/usr/bin/env bash

SPECIAL=`hyprctl monitors -j | jq .[0][\"specialWorkspace\"][\"name\"]`

SPECIAL=${SPECIAL//\"/}

[ $SPECIAL ] && hyprctl dispatch togglespecialworkspace ${SPECIAL:8}

res=$(hyprctl dispatch split:workspace $1)
# In case update broke the plugin
if [[ "$res" == "Invalid dispatcher" ]]; then
    hyprctl dispatch workspace $1
fi
