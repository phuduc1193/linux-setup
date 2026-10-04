# linux-setup

One hotkey: **Shift + Super + N** toggles silent mode.

What it does:
- Switches CPU profile to `power-saver` (quiet fans)
- Turns off RGB lighting
- Toggles back to `balanced` + restores brightness on second press

## Requirements

This is built for the [Ryoku](https://github.com/ryuk-desktop/ryoku) desktop on Arch/CachyOS:

- `hyprland` + Ryoku's Lua config loader
- `ryoku-hub` (for CPU profiles and lighting control)
- `ryoku-openrgb` + `ryoku-lighting-fx`
- `python3`, `notify-send`

## Install

```bash
git clone https://github.com/phuduc1193/linux-setup.git
cd linux-setup
./install.sh
```

## Files

| File | Goes to | Purpose |
|---|---|---|
| `hypr/user.lua` | `~/.config/hypr/user.lua` | Binds `Super+Shift+N` to `silent-toggle` |
| `bin/silent-toggle` | `~/.local/bin/silent-toggle` | The toggle script |
| `applications/silent-toggle.desktop` | `~/.local/share/applications/silent-toggle.desktop` | Launcher entry |

## Manual reload

```bash
ryoku wm act config.reload
```
