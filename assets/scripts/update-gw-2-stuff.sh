#!/usr/bin/env bash

LAUNCH_OPTIONS="-provider Portal -autologin"
GAME_DIR="$HOME/Games/Steam/Guild Wars 2"
WORKING_DIR="/tmp/gw2"

# ARCDPS and addons
ARC_URLS=(
    "https://www.deltaconnected.com/arcdps/x64/d3d11.dll"
    "https://github.com/Krappa322/arcdps_unofficial_extras_releases/releases/latest/download/arcdps_unofficial_extras.dll"
    "https://github.com/gw2scratch/arcdps-clears/releases/latest/download/arcdps_clears.dll"
    "https://github.com/knoxfighter/arcdps-killproof.me-plugin/releases/latest/download/d3d9_arcdps_killproof_me.dll"
    "https://github.com/MarsEdge/GW2-ArcDPS-Boon-Table/releases/latest/download/d3d9_arcdps_table.dll"
    "https://update.drf.rs/drf.dll"
)

# .bat file used to launch extra content (i.e. Blish HUD)
BAT_CONTENT="@echo off

cd \"%~dp0\"
echo %CD%
start \"\" \".\Gw2.exe\" $LAUNCH_OPTIONS
ping -n 5 127.0.0.1 > nul

rem Try to find Blish HUD
for /d %%i in (Blish.HUD*) do (
    echo Found directory: %%i
    set \"BHDIR=%%~fi\"
    goto :found
)

echo Blish.HUD* directory not found
pause
exit /b 1

:found
echo %BHDIR%
cd \"%BHDIR%\"
start \"\" \".\Blish HUD.exe\"
exit"

mkdir -p "$WORKING_DIR"
pushd "$WORKING_DIR"

# Find current Blish HUD
find_command=(find "$GAME_DIR" -type d -name "Blish*HUD*")
blish_hud_dir=$("${find_command[@]}")

# Fetch latest Blish HUD version
url=$(curl -s https://api.github.com/repos/blish-hud/Blish-HUD/releases/latest | grep browser_download_url | cut -d '"' -f 4)
if [ -z "$url" ]; then
    echo "Warning: No download URL found. Api rate limit?"
    exit 1
fi
blish_file_name=$(basename "$url")
blish_dir_name="${blish_file_name%.*}"

# If no Blish or version missmatch
if [ -z "$blish_hud_dir" ] || { [ "$blish_hud_dir" != "$GAME_DIR/$blish_dir_name" ] && rm -r "$blish_hud_dir"; }; then
    echo "No Blish HUD found, downloading $blish_dir_name"
    if ! curl -LO "$url"; then
        echo "Error: Failed to download $url"
        exit 1
    fi
    if ! unzip "$blish_file_name" -d "$GAME_DIR/$blish_dir_name"; then
        echo "Error: Failed to unzip $blish_file_name"
        exit 1
    fi
fi

# Replace exe file to lauch Blish anongside GW 2
if [ ! -e "$GAME_DIR/Gw2.exe" ]; then
    echo "No Gw2.exe found, fresh installation? Fixing..."
    url="https://github.com/jimmon89/Gw2-64.exe/releases/download/Latest/Gw2-64.exe"
    curl -LO "$url"
    mv "$GAME_DIR/Gw2-64.exe" "$GAME_DIR/Gw2.exe"
    mv "Gw2-64.exe" "$GAME_DIR/"

    echo "$BAT_CONTENT" > "$GAME_DIR/Gw2-64.bat"
fi

# Used for downloading ARCDPS and addons
download_and_replace() {
    local url=$1
    local filename=$(basename "${url}")
    local filepath="${GAME_DIR}/${filename}"

    wget -q --show-progress -O "${filename}" "${url}"

    # Check if download was successful
    if [ $? -eq 0 ]; then
        # If not exists or hash mismatch, replace
        if [ ! -e "${filepath}" ] || [ "$(sha256sum "${filename}" | cut -d ' ' -f 1)" != "$(sha256sum "${filepath}" | cut -d ' ' -f 1)" ]; then
            echo "Updating ${filename}..."
            mv -f "${filename}" "${filepath}"
        fi
    else
        echo "Failed to download ${filename}."
    fi
}

# Iterate over the URLs and call the function to download and replace files
for url in "${ARC_URLS[@]}"; do
    download_and_replace "${url}"
done

rm -r "$WORKING_DIR"

popd >/dev/null
