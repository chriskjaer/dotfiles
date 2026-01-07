local set = vim.opt

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.netrw_localrmdir = 'rm -r'

set.number = true
set.relativenumber = false
set.clipboard = 'unnamedplus'
set.updatetime = 300
set.ignorecase = true
set.smartcase = true
set.completeopt = { 'menu', 'menuone', 'noselect' }
set.pumheight = 10
set.timeoutlen = 400
set.ttimeoutlen = 10
set.confirm = true
set.shortmess:append({ I = true, c = true })

-- Colorscheme
set.termguicolors = true
set.background = 'dark'

local theme = vim.env.NVIM_THEME or ''
local uv = vim.uv or vim.loop
local uname = uv and uv.os_uname and uv.os_uname() or {}
local is_linux = uname.sysname == 'Linux'

if theme == '' and is_linux then
  local ok, lines = pcall(vim.fn.readfile, vim.fn.expand('~/.config/omarchy/current/theme/neovim.lua'))
  if ok and lines then
    local content = table.concat(lines, '\n')
    theme = content:match('colorscheme%s*=%s*"([^"]+)"') or content:match("colorscheme%s*=%s*'([^']+)'") or ''
  end
end

if theme == '' then
  theme = 'tokyonight-storm'
end

if theme == 'terminal' then
  set.termguicolors = false
  vim.cmd('colorscheme habamax')
elseif theme ~= '' then
  pcall(vim.cmd, 'colorscheme ' .. theme)
else
  vim.cmd('colorscheme habamax')
end

vim.g._theme = theme

local function apply_ui_tweaks()
  if theme == 'terminal' then
    vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'CursorLine' })
  end
end

vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_ui_tweaks })
apply_ui_tweaks()

set.splitright = true
set.splitbelow = true
pcall(function()
  set.splitkeep = 'screen'
end)

-- Softtabs, 2 spaces
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true

set.wrap = false
set.list = true
set.listchars = 'tab:»·,trail:·'
set.swapfile = false
set.showmatch = true
set.colorcolumn = '80'
set.undofile = true
set.writebackup = false
set.errorbells = false
set.visualbell = false
set.scrolloff = 10
set.fileformats = 'unix,dos,mac'
set.signcolumn = 'yes'
