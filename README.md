# chriskjaer dotfiles

Managed with thoughtbot's rcm:
https://github.com/thoughtbot/rcm

## Structure
- `common/`: shared across macOS + Linux (currently `nvim`, `tmux`).
- `macos/dotfiles/`: macOS-only dotfiles.
- `macos/`: macOS-only scripts + Brewfile.
- `linux/`: Linux notes + package lists (linux-only dotfiles go in `linux/dotfiles/`).

## Setup
macOS:
- `rcup -v -d ~/projects/dotfiles`
- Optional bootstrap: `bash scripts/bootstrap/darwin.sh`

Omarchy/Arch:
- `rcup -v -d ~/Work/dotfiles`
- Package lists live in `linux/packages.txt` and `linux/aur.txt`.

## Cursor config
Cursor settings are stored under `macos/Library/Application Support/Cursor/User`.
They are not auto-linked to avoid touching `~/Library`. If you want them linked:
- `ln -s "$HOME/projects/dotfiles/macos/Library/Application Support/Cursor/User" "$HOME/Library/Application Support/Cursor/User"`

## Credits
Thanks to the [Mathias Bynes](https://github.com/mathiasbynens/dotfiles), [Zach
Holman](https://github.com/holman/dotfiles), and [Thoughtbot's](https://github.com/thoughtbot/dotfiles) excellent dotfiles, which these are based on.
