#!/bin/bash
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
echo "==> Installing sword SDDM theme..."
sudo cp -r "$REPO/sword" /usr/share/sddm/themes/sword
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=sword\n' | sudo tee /etc/sddm.conf.d/10-theme.conf >/dev/null
sudo pacman -S --needed qt6-multimedia gst-plugins-good
echo "==> Done. Reboot to see the sword login."
