#!/bin/bash

# Find where the 'configs' repo folder is located on this machine
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
SOURCE_DIR="$REPO_DIR/wezterm"
TARGET_DIR="$HOME/.config/wezterm"

echo "🔗 Symlinking WezTerm configuration..."

# 1. Ensure the base ~/.config folder exists
mkdir -p "$HOME/.config"

# 2. Check if a real, physical folder already exists at ~/.config/wezterm
if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    echo "⚠️  Found existing config at $TARGET_DIR. Moving it to ${TARGET_DIR}.bak"
    mv "$TARGET_DIR" "${TARGET_DIR}.bak"
fi

# 3. Create the symbolic link pointing to your repo folder
# (-s = symbolic link, -f = force overwrite old link, -n = treat symlink target as a normal file)
ln -sfn "$SOURCE_DIR" "$TARGET_DIR"

echo "✅ Success! WezTerm is now using your repo's config."

