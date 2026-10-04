#!/bin/bash
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
echo "==> Ensuring SDDM (sword needs SDDM, not plasmalogin)..."
sudo pacman -S --needed sddm qt6-multimedia gst-plugins-good
if systemctl is-enabled plasmalogin &>/dev/null || systemctl is-active plasmalogin &>/dev/null; then
    sudo systemctl disable plasmalogin 2>/dev/null || true
fi
sudo systemctl enable sddm
echo "==> Installing sword SDDM theme..."
sudo cp -r "$REPO/sword" /usr/share/sddm/themes/sword
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=sword\n' | sudo tee /etc/sddm.conf.d/10-theme.conf >/dev/null
echo "==> Done. Reboot to see the sword login."
