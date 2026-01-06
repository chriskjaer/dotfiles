if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('config.options')
require('config.plugins')

if vim.g._packer_bootstrap then
  return
end

require('config.keymaps')
require('config.lsp')
require('config.autocmds')
require('config.local').load()

print('Neovim Config Loaded')
