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
- `RCRC=~/projects/dotfiles/rcrc rcup -v`
- Optional bootstrap: `bash scripts/bootstrap/darwin.sh`

Omarchy/Arch:
- `RCRC=~/Work/dotfiles/rcrc rcup -v`
- Package lists live in `linux/packages.txt` and `linux/aur.txt`.

## Cursor config
Cursor settings are stored under `macos/Library/Application Support/Cursor/User`.
They are not auto-linked to avoid touching `~/Library`. If you want them linked:
- `ln -s "$HOME/projects/dotfiles/macos/Library/Application Support/Cursor/User" "$HOME/Library/Application Support/Cursor/User"`

## Neovim Ruby LSP
Assumptions/requirements:
- Ruby + Bundler available (`bundle` in PATH; mise shims are added).
- Repo root detected by `Gemfile` or `.git`.
- `srb` available for Sorbet (`sorbet/config` should only include `--` flags; no `--dir/--file` entries).
- Ruby LSP starts via:
  - `bundle exec ruby-lsp` if the repo includes the gem, else
  - composed bundle at `.ruby-lsp/Gemfile` (sets `BUNDLE_GEMFILE`).
- `ruby-lsp` may auto-run `bundle install` for the composed bundle.
- RuboCop LSP from Mason is disabled; diagnostics run through none-ls with `bundle exec rubocop`.
- Ruby formatting uses Syntax Tree (`bundle exec stree format` when a `Gemfile` is present, else global `stree`).
- Set `NVIM_FORMAT_RUBY=0` to disable Ruby auto-format on save.

## Credits
Thanks to the [Mathias Bynes](https://github.com/mathiasbynens/dotfiles), [Zach
Holman](https://github.com/holman/dotfiles), and [Thoughtbot's](https://github.com/thoughtbot/dotfiles) excellent dotfiles, which these are based on.
