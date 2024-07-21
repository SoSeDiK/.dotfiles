#!/usr/bin/env bash

# Interval in seconds
interval=0.1

# If using repeat, need to update toggle's script process to kill
# ydotool click --repeat 999999 --next-delay 10 0xC0 # LMB
while true; do
    ydotool click 0xC0 # LMB
    sleep $interval
done
