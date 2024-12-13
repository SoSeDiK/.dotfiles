#!/usr/bin/env sh

capslock=$(cat /sys/class/leds/input2::capslock/brightness)

kblayout=$(hyprctl devices -j | jq -r ".keyboards.[0].active_keymap")

getLayoutName() {
  local keymap=$1
  if [ "$keymap" == "English (US)" ]; then
    echo "en"
  elif [ "$keymap" == "Russian-Ukrainian (United)" ]; then
    echo "ua"
  else
    echo "$keymap"
  fi
}

kblayout=$(getLayoutName "$kblayout")

if [[ "$capslock" == "1" ]]; then
    echo -n "󰘲 "
fi

echo "$kblayout"
