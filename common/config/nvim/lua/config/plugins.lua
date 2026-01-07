local function ensure_packer()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local is_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  use('nvim-tree/nvim-web-devicons')
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    event = 'VimEnter',
    config = function()
      require('config.ui').lualine()
    end,
  })

  use({
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigateNext',
    },
  })

  use('folke/tokyonight.nvim')
  use({ 'junegunn/goyo.vim', cmd = { 'Goyo' } })

  use({
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  })

  use({
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end,
  })

  use({ 'tpope/vim-abolish', event = { 'BufReadPost', 'BufNewFile' } })
  use({ 'tpope/vim-fugitive', cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GRename' } })
  use({ 'tpope/vim-repeat', event = { 'BufReadPost', 'BufNewFile' } })
  use({ 'tpope/vim-surround', event = { 'BufReadPost', 'BufNewFile' } })
  use({ 'tpope/vim-unimpaired', event = { 'BufReadPost', 'BufNewFile' } })

  use({
    'stevearc/oil.nvim',
    config = function()
      require('config.oil').setup()
    end,
  })

  use({
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      local ok, copilot = pcall(require, 'copilot')
      if not ok then
        return
      end
      copilot.setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  })

  use({
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function()
      local ok, copilot_cmp = pcall(require, 'copilot_cmp')
      if not ok then
        return
      end
      copilot_cmp.setup()
    end,
  })

  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.cmp').setup()
    end,
  })
  use({ 'hrsh7th/cmp-buffer', after = 'nvim-cmp' })
  use({ 'hrsh7th/cmp-path', after = 'nvim-cmp' })
  use({ 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' })
  use({ 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' })
  use({ 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' })
  use({ 'L3MON4D3/LuaSnip', after = 'nvim-cmp' })
  use({ 'rafamadriz/friendly-snippets', after = 'nvim-cmp' })

  use('neovim/nvim-lspconfig')
  use('williamboman/mason.nvim')
  use('williamboman/mason-lspconfig.nvim')

  use({
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  })

  use({
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
    config = function()
      require('fidget').setup({})
    end,
  })

  use({
    'folke/trouble.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' },
    config = function()
      require('trouble').setup({})
    end,
  })

  use({
    'nvimtools/none-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('config.null_ls').setup()
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('config.treesitter').setup()
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    cmd = 'Telescope',
    config = function()
      require('config.telescope').setup()
    end,
  })

  use({
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = { 'Octo' },
    config = function()
      require('octo').setup()
    end,
  })

  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('config.ui').gitsigns()
    end,
  })

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  vim.g._packer_bootstrap = true
  print('==================================')
  print('    Plugins are being installed')
  print('    Wait until Packer completes,')
  print('       then restart nvim')
  print('==================================')
end
