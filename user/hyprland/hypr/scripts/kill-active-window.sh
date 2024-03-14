#!/usr/bin/env bash
kill -9 $(hyprctl activewindow | awk '/pid:/ {print $2}')
