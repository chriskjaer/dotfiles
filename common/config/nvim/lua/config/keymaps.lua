local bind = vim.keymap.set
local opts = { silent = true, noremap = true }

bind('n', '<leader><leader>', '<c-^>')

-- Oil.nvim keybindings
bind('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
bind('n', '<leader>-', '<cmd>Oil .<cr>', { desc = 'Open current working directory' })
bind('n', '<leader>o', '<cmd>Oil --float<cr>', { desc = 'Open oil in floating window' })

local printError = vim.api.nvim_err_writeln
bind('n', '<Left>', function()
  printError('Use h')
end)
bind('n', '<Right>', function()
  printError('Use l')
end)
bind('n', '<Up>', function()
  printError('Use k')
end)
bind('n', '<Down>', function()
  printError('Use j')
end)

-- Quicker window movement
bind('n', '<C-h>', ':TmuxNavigateLeft<cr>', opts)
bind('n', '<C-j>', ':TmuxNavigateDown<cr>', opts)
bind('n', '<C-k>', ':TmuxNavigateUp<cr>', opts)
bind('n', '<C-l>', ':TmuxNavigateRight<cr>', opts)

-- Reselect visual block after indent/outdent
bind('v', '<', '<gv')
bind('v', '>', '>gv')

-- Fast saving
bind('n', '<leader>w', '<cmd>w<cr>')

-- Vim config
local function reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match('^config') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath('config') .. '/init.lua')
  vim.notify('Reloaded Neovim config', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ReloadConfig', reload_config, {})
bind('n', '<leader>cr', '<cmd>ReloadConfig<cr>', { desc = 'Reload Neovim config' })
bind('n', '<leader>ce', '<cmd>e $MYVIMRC<cr>')

-- disable EX mode
bind('n', 'Q', '<nop>')

bind({ 'i', 'c' }, 'jj', '<esc>')
bind({ 'i', 'c' }, 'jk', '<esc>')

-- Use esc to exit terminal mode
bind('t', '<esc>', '<C-\\><C-n>')

-- Clear search highlight on hitting esc
bind('n', '<esc>', ':noh<return><esc>', opts)

-- Theme toggle
bind('n', '<leader>tt', function()
  if vim.fn.executable('toggle-theme') == 1 then
    os.execute('toggle-theme')
    vim.cmd('source $MYVIMRC')
  else
    vim.notify('toggle-theme not available on this system', vim.log.levels.WARN)
  end
end, { desc = 'Toggle light/dark theme' })

-- Telescope
bind('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
bind('n', '<C-p>', '<cmd>Telescope find_files<cr>', opts)
bind('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
bind('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
bind('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)
bind('n', '<leader>fw', '<cmd>Telescope grep_string<cr>', opts)

-- Trouble
bind('n', '<leader>xx', '<cmd>TroubleToggle<cr>', opts)
bind('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', opts)
bind('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)

-- Additional diagnostic keybindings
bind('n', '[d', vim.diagnostic.goto_prev, opts)
bind('n', ']d', vim.diagnostic.goto_next, opts)
bind('n', '<leader>e', vim.diagnostic.open_float, opts)
bind('n', '<leader>q', vim.diagnostic.setloclist, opts)
