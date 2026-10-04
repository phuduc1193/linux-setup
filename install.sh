#!/bin/bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing silent-mode files..."
mkdir -p ~/.config/hypr ~/.config/OpenRGB/profiles ~/.local/bin ~/.local/share/applications

cp "$REPO/bin/silent-toggle" ~/.local/bin/silent-toggle
chmod +x ~/.local/bin/silent-toggle

cp "$REPO/applications/silent-toggle.desktop" ~/.local/share/applications/silent-toggle.desktop

# Hyprland keybind (Ryoku Lua or standard conf)
if [ -f ~/.config/hypr/hyprland.lua ] || command -v ryoku &>/dev/null; then
    cp "$REPO/hypr/user.lua" ~/.config/hypr/user.lua
    echo "    Ryoku Hyprland config installed to ~/.config/hypr/user.lua"
else
    # Append the bind if not already present
    if [ ! -f ~/.config/hypr/hyprland.conf ]; then
        echo "    WARNING: ~/.config/hypr/hyprland.conf not found, skipping keybind."
        echo "    Add this line manually once Hyprland is configured:"
        cat "$REPO/hypr/hyprland.conf"
    elif ! grep -q "silent-toggle" ~/.config/hypr/hyprland.conf 2>/dev/null; then
        cat "$REPO/hypr/hyprland.conf" >> ~/.config/hypr/hyprland.conf
        echo "    Standard Hyprland bind appended to ~/.config/hypr/hyprland.conf"
    fi
fi

# Ensure ~/.local/bin is on PATH for this session
export PATH="$HOME/.local/bin:$PATH"

echo "==> Checking power-profiles-daemon..."
if command -v powerprofilesctl &>/dev/null; then
    sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true
else
    echo "    powerprofilesctl not found. Install power-profiles-daemon for CPU profile switching:"
    echo "      sudo pacman -S power-profiles-daemon"
fi

echo "==> Checking OpenRGB..."
if ! command -v openrgb &>/dev/null; then
    echo "    openrgb not found. Install it with:"
    echo "      sudo pacman -S openrgb"
    exit 1
fi

if ! systemctl is-active --quiet openrgb.service 2>/dev/null; then
    echo "    NOTE: openrgb.service is not running. The toggle uses direct"
    echo "    hardware access and does not need it, but other apps (e.g. SDK"
    echo "    clients on port 6742) do. Start it with:"
    echo "      sudo systemctl enable --now openrgb.service"
fi

echo "==> Checking kernel cmdline for acpi_enforce_resources=lax..."
if ! grep -q "acpi_enforce_resources=lax" /proc/cmdline; then
    echo "    RAM RGB needs acpi_enforce_resources=lax in the kernel cmdline."
    echo "    Add it to your bootloader and reboot. Common locations:"
    echo "      systemd-boot: /boot/loader/entries/*.conf"
    echo "      GRUB:         /etc/default/grub  -> GRUB_CMDLINE_LINUX_DEFAULT"
    echo "      limine:       /etc/default/limine -> KERNEL_CMDLINE[default]"
fi

echo "==> Building initial OpenRGB profiles..."
~/.local/bin/silent-toggle --init || true

echo "==> Done. Press Super+Shift+N to toggle silent mode."
