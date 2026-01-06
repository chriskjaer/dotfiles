# AGENTS.md

## Commit style
- Dotfiles commits use a single dot message: `.`
- Do not amend commits unless explicitly asked.

## Testing Neovim changes
- Quick sanity check:
  - `nvim --headless +"lua print('nvim ok')" +qa`
- After plugin list changes, run `:PackerSync` inside Neovim and wait for installs to finish.
- Headless sync (when needed):
  - `nvim --headless +'autocmd User PackerComplete quitall' +PackerSync`
- If LSP changes are involved, open a representative file and verify `:LspInfo` shows expected clients.

## Local project config
- Create a `.nvim.lua` file in a project root to set project-specific options.
- On first load you will be prompted; choose “Always” to trust and persist it.
- Trusted paths are stored in `~/.local/share/nvim/local-config.json`.

## Lua formatting/linting (repo usage)
- Format: `stylua config/nvim`
- Lint: `selene config/nvim`
- After any Neovim config changes, run both commands.

## Notes
- Keep changes safe for macOS; Linux-only tweaks must stay OS-gated when needed.
