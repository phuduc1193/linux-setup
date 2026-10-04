# linux-setup

One hotkey: **Shift + Super + N** toggles silent mode.

What it does:
- Switches CPU profile to `power-saver`
- Turns off all RGB lighting through OpenRGB
- Toggles back to `balanced` + restores the previous lighting on second press

No Ryoku required.

## Hardware this was built for

- Gigabyte B650 GAMING X AX V2
- Corsair Vengeance RGB DDR5 (2 sticks on SMBus 0x19 + 0x1B)
- Keychron RGB keyboard
- LG 27GN950-B monitor

## Requirements

- Arch/CachyOS with Hyprland
- `openrgb` package + `openrgb.service` running
- `powerprofilesctl` (from `power-profiles-daemon`, usually installed)
- Kernel boot parameter: `acpi_enforce_resources=lax`
  - Without this, the FCH SMBus stays disabled and the RAM sticks will **not** appear in OpenRGB.

## Install

```bash
git clone https://github.com/phuduc1193/linux-setup.git
cd linux-setup
./install.sh
```

Then add `acpi_enforce_resources=lax` to your kernel cmdline and reboot:

- **systemd-boot**: edit `/boot/loader/entries/*.conf`
- **GRUB**: edit `/etc/default/grub` → `GRUB_CMDLINE_LINUX_DEFAULT`, then `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- **limine**: edit `/etc/default/limine` → `KERNEL_CMDLINE[default]`

## Files

| File | Goes to | Purpose |
|---|---|---|
| `hypr/hyprland.conf` | appended to `~/.config/hypr/hyprland.conf` | Standard Hyprland bind |
| `hypr/user.lua` | `~/.config/hypr/user.lua` | Ryoku Lua bind (only if Ryoku is present) |
| `bin/silent-toggle` | `~/.local/bin/silent-toggle` | The toggle script |
| `applications/silent-toggle.desktop` | `~/.local/share/applications/silent-toggle.desktop` | Launcher entry |

## How it works

`silent-toggle` talks to the running OpenRGB server on `127.0.0.1:6742` using the
`openrgb` CLI. It keeps two profiles in `~/.config/OpenRGB/profiles/`:

- `normal` — whatever lighting is active when you press the hotkey
- `silent` — all LEDs set to `#000000`

On first run it creates both profiles. After that it just loads one or the other.

## Manual commands

```bash
# Initialize the two profiles without toggling
silent-toggle --init

# Toggle
silent-toggle
```

## Troubleshooting

### RAM sticks don't appear in OpenRGB

You forgot the kernel parameter. Run:

```bash
grep acpi_enforce_resources /proc/cmdline
```

If it's missing, add `acpi_enforce_resources=lax`, rebuild your bootloader config, and reboot.

### openrgb service not running

```bash
sudo systemctl enable --now openrgb.service
```
