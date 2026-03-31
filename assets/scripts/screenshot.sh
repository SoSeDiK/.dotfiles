#!/usr/bin/env bash

set -o pipefail   # Catch errors in pipelines
set -u            # Treat unset variables as errors

OUTPUT_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
readonly OUTPUT_DIR

# ------------------------------------------------------------------------------
# Helper: perform the actual capture, save to file, and copy to clipboard
# Arguments: all arguments are passed directly to grim
# ------------------------------------------------------------------------------
capture_common() {
    mkdir -p "$OUTPUT_DIR" || {
        echo "Error: Cannot create output directory '$OUTPUT_DIR'" >&2
        exit 1
    }

    local timestamp
    timestamp=$(date "+%Y-%m-%d-%H-%M-%S")
    local filepath="$OUTPUT_DIR/screenshot-$timestamp.png"

    # Capture, save to file, and copy to clipboard
    if ! grim "$@" - | tee "$filepath" | wl-copy; then
        echo "Error: Failed to capture or save screenshot" >&2
        return 1
    fi

    # Send notification with an action to edit the screenshot
    (
        local action
        action=$(notify-send "Screenshot saved to clipboard and file" \
            "Edit with Super + Alt + , (or click this)" \
            -t 10000 -i "$filepath" -A "default=edit" 2>/dev/null || true)
        if [[ "$action" == "default" ]]; then
            open_editor "$filepath"
        fi
    ) &
}

# ------------------------------------------------------------------------------
# Capture a selected region using slurp
# ------------------------------------------------------------------------------
capture_region() {
    local region
    region=$(slurp 2>/dev/null) || true
    if [[ -z "$region" ]]; then
        return   # User cancelled, nothing to capture
    fi
    capture_common -c -g "$region"
}

# ------------------------------------------------------------------------------
# Capture the currently focused window using hyprctl
# ------------------------------------------------------------------------------
capture_window() {
    if ! command -v hyprctl &>/dev/null; then
        echo "Error: hyprctl not found" >&2
        return 1
    fi
    if ! command -v jq &>/dev/null; then
        echo "Error: jq not found" >&2
        return 1
    fi

    local addr
    addr=$(hyprctl activewindow -j 2>/dev/null | jq -r '.address')
    if [[ -z "$addr" || "$addr" == "null" ]]; then
        echo "No active window found" >&2
        return 1
    fi
    capture_common -w "$addr"
}

# ------------------------------------------------------------------------------
# Capture the currently focused monitor using hyprctl
# ------------------------------------------------------------------------------
capture_monitor() {
    if ! command -v hyprctl &>/dev/null; then
        echo "Error: hyprctl not found" >&2
        return 1
    fi
    if ! command -v jq &>/dev/null; then
        echo "Error: jq not found" >&2
        return 1
    fi

    local monitor
    monitor=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | .name')
    if [[ -z "$monitor" || "$monitor" == "null" ]]; then
        echo "No focused monitor found" >&2
        return 1
    fi
    capture_common -c -o "$monitor"
}

# ------------------------------------------------------------------------------
# Main dispatcher – called from the after‑freeze‑cmd
# ------------------------------------------------------------------------------
take_screenshot() {
    # Ensure wayfreeze is terminated when this function exits
    trap 'killall wayfreeze 2>/dev/null' EXIT

    local mode="${1:-region}"
    case "$mode" in
        region)  capture_region ;;
        window)  capture_window ;;
        monitor) capture_monitor ;;
        *)
            echo "Error: Unknown mode '$mode'" >&2
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Open the screenshot in satty for editing
# ------------------------------------------------------------------------------
open_editor() {
    local filepath="$1"
    satty --filename "$filepath" \
        --output-filename "$filepath" \
        --actions-on-enter save-to-clipboard \
        --save-after-copy \
        --copy-command 'wl-copy'
}

# ------------------------------------------------------------------------------
# Script entry point – runs wayfreeze with the appropriate after‑freeze‑cmd
# ------------------------------------------------------------------------------
main() {
    local mode="${1:-region}"

    # Export all needed functions so they are available in the subshell
    export -f capture_common capture_region capture_window capture_monitor take_screenshot open_editor
    export OUTPUT_DIR

    # Build the command that will run inside the frozen screen
    local after_freeze_cmd="bash -c 'take_screenshot $mode'"

    wayfreeze --after-freeze-cmd "$after_freeze_cmd"
}

# Run main only if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
