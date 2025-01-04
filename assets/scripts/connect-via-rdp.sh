#!/usr/bin/env bash

source ~/.dotfiles/assets/scripts/start-win-wm.sh

sleep 20

xfreerdp -grab-keyboard /v:192.168.100.252 /u:SoSeDiK /p:PASSWORD /size:100% /d: /dynamic-resolution /audio-mode:1 /gfx-h264:avc444 +gfx-progressive +auto-reconnect /auto-reconnect-max-retries:20 &

exit
