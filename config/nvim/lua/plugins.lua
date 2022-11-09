local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local k = vim.keymap

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use("tpope/vim-repeat")
	use("joshdick/onedark.vim")
	use("tpope/vim-abolish")
	use("tpope/vim-unimpaired")
	use("christoomey/vim-tmux-navigator")
	use("spf13/vim-autoclose")
	use("tpope/vim-surround")
	use("tomtom/tcomment_vim")
	use("dyng/ctrlsf.vim")
	use("tpope/vim-fugitive")
	use("rking/ag.vim")
	use("tpope/vim-vinegar")
	use("junegunn/goyo.vim")

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})

	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				sources = {
					["null-ls"] = { ignore = true },
				},
			})
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({})

			local opts = { silent = true, noremap = true }
			k.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
			k.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
			k.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
		end,
	})

	use("jose-elias-alvarez/null-ls.nvim")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			local builtin = require("telescope.builtin")

			local opts = { silent = true, noremap = true }
			k.set("n", "<leader>ff", builtin.find_files, opts)
			k.set("n", "<C-p>", builtin.find_files, opts)
			k.set("n", "<leader>fg", builtin.live_grep, opts)
			k.set("n", "<leader>fb", builtin.buffers, opts)
			k.set("n", "<leader>fh", builtin.help_tags, opts)
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
