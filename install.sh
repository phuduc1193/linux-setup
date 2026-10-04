#!/bin/bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.config/hypr ~/.local/bin ~/.local/share/applications

# Hyprland keybind
cp "$REPO/hypr/user.lua" ~/.config/hypr/user.lua

# Toggle script
cp "$REPO/bin/silent-toggle" ~/.local/bin/silent-toggle
chmod +x ~/.local/bin/silent-toggle

# Launcher entry
cp "$REPO/applications/silent-toggle.desktop" ~/.local/share/applications/silent-toggle.desktop

# Ensure ~/.local/bin is on PATH for this session if it wasn't already
export PATH="$HOME/.local/bin:$PATH"

if command -v ryoku &>/dev/null; then
    ryoku wm act config.reload
fi

echo "Installed. Press Super+Shift+N to toggle silent mode."
