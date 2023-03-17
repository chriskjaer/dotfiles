local bind = vim.keymap.set
local opts = { silent = true, noremap = true }
local set = vim.opt

vim.g.mapleader = ","

-- Allow netrw to remove non-empty local directories
vim.g.netrw_localrmdir = "rm -r"

set.number = true
set.clipboard = "unnamedplus"
set.updatetime = 300

-- Colorscheme
set.termguicolors = true
vim.cmd("colorscheme onedark")

-- Open new split panes to right and bottom, which feels more natural
set.splitright = true
set.splitbelow = true

-- Softtabs, 2 spaces
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true

set.wrap = false
set.list = true
set.listchars = "tab:»·,trail:·"
set.swapfile = false
set.showmatch = true
set.colorcolumn = "80"
set.undofile = true
set.writebackup = false
set.errorbells = false
set.visualbell = false
set.scrolloff = 10
set.fileformats = "unix,dos,mac"

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use("kyazdani42/nvim-web-devicons")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use("christoomey/vim-tmux-navigator")
	use("joshdick/onedark.vim")
	use("junegunn/goyo.vim")
	use("spf13/vim-autoclose")
	use("tomtom/tcomment_vim")
	use("tpope/vim-abolish")
	use("tpope/vim-fugitive")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-unimpaired")
	use("tpope/vim-vinegar")

	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	})

	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	})

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
	})

	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	})

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
-- local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	command = "source <afile> | PackerCompile",
-- 	group = packer_group,
-- 	pattern = vim.fn.expand("$MYVIMRC"),
-- })

-- Keybindings
--------------------------------------------------------------------------------
bind("n", "<leader><leader>", "<c-^>") -- Switch between the last two files

local printError = vim.api.nvim_err_writeln
bind("n", "<Left>", function()
	printError("Use h")
end)
bind("n", "<Right>", function()
	printError("Use l")
end)
bind("n", "<Up>", function()
	printError("Use k")
end)
bind("n", "<Down>", function()
	printError("Use j")
end)

-- Quicker window movement
bind("n", "<C-h>", "<C-w>h")
bind("n", "<C-j>", "<C-w>j")
bind("n", "<C-k>", "<C-w>k")
bind("n", "<C-l>", "<C-w>l")

-- Reselect visual block after indent/outdent
bind("v", "<", "<gv")
bind("v", ">", ">gv")

-- Fast saving
bind("n", "<leader>w", "<cmd>w<cr>")

-- Vim config
bind("n", "<leader>cr", "<cmd>source $MYVIMRC<cr>")
bind("n", "<leader>ce", "<cmd>e $MYVIMRC<cr>")

-- disable EX mode for now. Enable when I'm an adult and know how to use my editor
bind("n", "Q", "<nop>")

bind({ "i", "c" }, "jj", "<esc>")
bind({ "i", "c" }, "jk", "<esc>")

-- Use esc to exit terminal mode
bind("t", "<esc>", "<C-\\><C-n>")

-- Clear search highlight on hitting esc
bind("n", "<esc>", ":noh<return><esc>", opts)

-- Tmux
--------------------------------------------------------------------------------

vim.g.tmux_navigator_no_mappings = 1
bind("n", "<C-h>", ":TmuxNavigateLeft<cr>", opts)
bind("n", "<C-j>", ":TmuxNavigateDown<cr>", opts)
bind("n", "<C-k>", ":TmuxNavigateUp<cr>", opts)
bind("n", "<C-l>", ":TmuxNavigateRight<cr>", opts)

-- LSP
--------------------------------------------------------------------------------
local lsp = require("lsp-zero")
lsp.preset("recommended")

local cmp = require("cmp")
local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

lsp.setup_nvim_cmp({
	mapping = lsp.defaults.cmp_mappings({
		["<Tab>"] = vim.schedule_wrap(function(fallback)
			if cmp.visible() and has_words_before() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
	}),
	sources = {
		{ name = "copilot", group_index = 2 },
		{ name = "path", group_index = 2 },
		{ name = "nvim_lsp", group_index = 2, keyword_length = 3 },
		{ name = "buffer", group_index = 2, keyword_length = 3 },
		{ name = "luasnip", group_index = 2, keyword_length = 2 },
	},
})

lsp.setup()

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.denols.setup({
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
})

lspconfig.tsserver.setup({
	root_dir = lspconfig.util.root_pattern("package.json"),
})

lspconfig.syntax_tree.setup({})

vim.diagnostic.config({ virtual_text = true })

local null_ls = require("null-ls")

local lsp_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end

local null_opts = lsp.build_options("null-ls", {
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = lsp_augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = lsp_augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})

null_ls.setup({
	root_dir = require("null-ls.utils").root_pattern(".git", "pnpm-workspace.yaml", "Gemfile"),

	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		bind("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
		bind("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		bind("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
		bind("n", "gr", vim.lsp.buf.references, bufopts)
		bind("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, bufopts)
	end,

	sources = {
		-- null_ls.builtins.formatting.black,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.eslint_d,
		-- null_ls.builtins.formatting.deno_fmt,
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.formatting.sqlfluff,
		null_ls.builtins.formatting.rubocop,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml", "markdown" },
		}),
		null_ls.builtins.formatting.shfmt,
	},
})

-- Tresitter
--------------------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
	ensure_install = { "typescript", "lua", "json", "ruby" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- Telescope
--------------------------------------------------------------------------------
local builtin = require("telescope.builtin")
bind("n", "<leader>ff", builtin.find_files, opts)
bind("n", "<C-p>", builtin.find_files, opts)
bind("n", "<leader>fg", builtin.live_grep, opts)
bind("n", "<leader>fb", builtin.buffers, opts)
bind("n", "<leader>fh", builtin.help_tags, opts)
bind("n", "<leader>fw", function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, opts)

-- Trouble
--------------------------------------------------------------------------------
bind("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
bind("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
bind("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
--------------------------------------------------------------------------------

-- Lualine
--------------------------------------------------------------------------------
require("lualine").setup()

print("Neovim Config Loaded")

-- Misc
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("init_cmds", { clear = true })

autocmd("FileType", {
	group = augroup,
	pattern = { "qf", "help", "man", "lspinfo", "harpoon", "null-ls-info" },
	command = "nnoremap <buffer> q <cmd>quit<cr>",
})

autocmd("FileType", {
	group = augroup,
	pattern = { "text", "markdown" },
	command = "setlocal textwidth=80",
})

autocmd("FileType", {
	group = augroup,
	pattern = { "javascript", "typescript" },
	command = "nmap <Leader>cl yiwoconsole.log('<C-r>\"', <C-r>\")<esc>^",
})
