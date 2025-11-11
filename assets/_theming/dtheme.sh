#!/usr/bin/env bash

set -e
pushd ~/.dotfiles/assets/_theming

APPS=(
  "kitty,kitty,~/.config/kitty/current-theme.conf"
  "codium,vscode,~/.vscode-oss/extensions/dyntheme.{{scheme-id}}/themes/theme.json"
)

# Function to list available themes
list_themes() {
    echo "Available themes:"
    for theme_file in ./themes/*.yaml; do
        # Extract just the filename without path and extension
        theme_name=$(basename "$theme_file" .yaml)
        
        # Optional: Extract system and variant for more info
        system=$(awk '/^system:/ {print $2}' "$theme_file" | tr -d '"')
        variant=$(awk '/^variant:/ {print $2}' "$theme_file" | tr -d '"')
        
        # Print theme name with system and variant
        printf "  %-30s [%s - %s]\n" "$theme_name" "$system" "$variant"
    done
}

# Check for --themes flag
if [ "$1" = "--themes" ]; then
    list_themes
    exit 0
fi

# Check if theme name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <theme_name> or $0 --themes"
    exit 1
fi

THEME_NAME="$1"
THEME_PATH="./themes/${THEME_NAME}.yaml"

# Check if theme file exists
if [ ! -f "$THEME_PATH" ]; then
    echo "Error: Theme file ${THEME_PATH} not found"
    exit 1
fi

# Extract theme information
SYSTEM=$(grep "^system:" "$THEME_PATH" | cut -d'"' -f2)
NAME=$(grep "^name:" "$THEME_PATH" | cut -d'"' -f2)
DESCRIPTION=$(grep "^description:" "$THEME_PATH" | cut -d'"' -f2)
AUTHOR=$(grep "^author:" "$THEME_PATH" | cut -d'"' -f2)
VARIANT=$(grep "^variant:" "$THEME_PATH" | cut -d'"' -f2)

if [[ "$SYSTEM" != "base16" && "$SYSTEM" != "base24" ]]; then
    echo "Error: Unsupported scheme system: '$SYSTEM' (must be base16 or base24)"
    exit 1
fi

# Build sed expressions for base00-base0F and optionally base10-base17
sed_exprs=(
    -e "s/{{scheme-id}}/${THEME_NAME}/g"
    -e "s/{{scheme-system}}/${SYSTEM}/g"
    -e "s/{{scheme-name}}/${NAME}/g"
    -e "s/{{scheme-variant}}/${VARIANT}/g"
    -e "s/{{scheme-description}}/${DESCRIPTION}/g"
    -e "s|{{scheme-author}}|${AUTHOR}|g"
)
end=$(( SYSTEM == "base24" ? 23 : 15 ))

for i in $(seq 0 $end); do
    hex_digit=$(printf "%X" "$i")
    if [ "$i" -lt 16 ]; then
        base_name="base0${hex_digit}"
    else
        base_name="base${hex_digit}"
    fi

    color_val=$(awk -v col="${base_name}:" '$0 ~ col { gsub(/"/, "", $2); print $2 }' "$THEME_PATH")
    if [ -n "$color_val" ]; then
        sed_exprs+=("-e" "s/#{{${base_name}-hex}}/${color_val}/g")
        sed_exprs+=("-e" "s/{{${base_name}-hex}}/${color_val}/g")
    fi
done

# === PROCESS EACH APP ===
for app_entry in "${APPS[@]}"; do
    IFS=',' read -r app_name template_base raw_output_path <<< "$app_entry"

    # Skip if template_base is empty (disabled app)
    if [ -z "$template_base" ]; then
        continue
    fi

    # Resolve ~ in output path
    output_path="${raw_output_path/#\~/$HOME}"
    # Replace id
    output_path="${output_path//\{\{scheme-id\}\}/$THEME_NAME}"
    template_path="./templates/${template_base}-${SYSTEM}.mustache"

    if [ ! -f "$template_path" ]; then
        echo "⚠️  Skipping $app_name: template not found ($template_path)"
        continue
    fi

    # Ensure output directory exists
    mkdir -p "$(dirname "$output_path")"

    # Apply template
    sed "${sed_exprs[@]}" "$template_path" > "$output_path"
    echo "✅ Updated $app_name theme: $output_path"
done

# kitty
pkill -SIGUSR1 kitty

# Codium
extensions_path="$HOME/.vscode-oss/extensions"
extension_path="$extensions_path/dyntheme.$THEME_NAME"
extension_json="$extension_path/package.json"
if [ ! -f "$extension_json" ]; then
    # cp "./assets/vscode-theme.json" "$extension_json"
    sed "${sed_exprs[@]}" "./assets/vscode-theme.json" > "$extension_json"
    rm "$extensions_path/extensions.json" # To make VS Code refresh extensions
    sleep 2
fi
settings_path="$HOME/.config/VSCodium/User/settings.json"
jq --arg theme "Dynamic: $NAME" '.["workbench.colorTheme"] = $theme' "$settings_path" > "$settings_path.new" && cat "$settings_path.new" > "$settings_path" && rm "$settings_path.new"

notify-send "   Applied theme $NAME"
