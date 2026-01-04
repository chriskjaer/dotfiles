local bind = vim.keymap.set
local opts = { silent = true, noremap = true }
local set = vim.opt

vim.g.mapleader = ","

-- Allow netrw to remove non-empty local directories
vim.g.netrw_localrmdir = "rm -r"

set.number = true
set.relativenumber = false
set.clipboard = "unnamedplus"
set.updatetime = 300
set.ignorecase = true
set.smartcase = true

-- Colorscheme
set.termguicolors = true
set.background = "dark"
local theme = vim.env.NVIM_THEME or ""
local uv = vim.uv or vim.loop
local uname = uv and uv.os_uname and uv.os_uname() or {}
local is_linux = uname.sysname == "Linux"

if theme == "" and is_linux then
	local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua"))
	if ok and lines then
		local content = table.concat(lines, "\n")
		theme = content:match('colorscheme%s*=%s*"([^"]+)"') or content:match("colorscheme%s*=%s*'([^']+)'") or ""
	end
end
if theme == "" and is_linux then
	theme = "terminal"
end

if theme == "terminal" then
	-- Use terminal palette (16 colors) by default
	set.termguicolors = false
	vim.cmd("colorscheme habamax")
elseif theme ~= "" then
	pcall(vim.cmd, "colorscheme " .. theme)
else
	pcall(vim.cmd, "colorscheme onedark")
end

local function apply_ui_tweaks()
	if theme == "terminal" then
		vim.api.nvim_set_hl(0, "ColorColumn", { link = "CursorLine" })
	end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_ui_tweaks })
apply_ui_tweaks()

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
set.signcolumn = "yes"

local function setup_oil()
	if vim.g._oil_configured then
		return
	end
	local ok, oil = pcall(require, "oil")
	if not ok then
		return
	end
	oil.setup({
		-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
		default_file_explorer = true,
		-- Id is automatically added at the beginning, and name at the end
		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtime",
		},
		-- Buffer-local options to use for oil buffers
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},
		-- Window-local options to use for oil buffers
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},
		-- Send deleted files to the trash instead of permanently deleting them
		delete_to_trash = true,
		-- Skip the confirmation popup for simple operations
		skip_confirm_for_simple_edits = false,
		-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
		prompt_save_on_select_new_entry = true,
		-- Oil will automatically delete hidden buffers after this delay
		cleanup_delay_ms = 2000,
		-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-t>"] = "actions.select_tab",
			["p"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-r>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		-- Set to false to disable all of the above keymaps
		use_default_keymaps = false,
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function(name, bufnr)
				return false
			end,
			sort = {
				-- sort order can be "asc" or "desc"
				-- see :help oil-columns to see which columns are sortable
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
		-- Configuration for the floating window in oil.open_float
		float = {
			-- Padding around the floating window
			padding = 2,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- This is the config that will be passed to nvim_open_win.
			-- Change values here to customize the layout
			override = function(conf)
				return conf
			end,
		},
		-- Configuration for the actions floating preview window
		preview = {
			-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_width and max_width can be a single value or a list of mixed integer/float types.
			-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
			max_width = 0.9,
			-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
			min_width = { 40, 0.4 },
			-- optionally define an integer/float for the exact width of the preview window
			width = nil,
			-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_height and max_height can be a single value or a list of mixed integer/float types.
			-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
			max_height = 0.9,
			-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
			min_height = { 5, 0.1 },
			-- optionally define an integer/float for the exact height of the preview window
			height = nil,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
		-- Configuration for the floating progress window
		progress = {
			max_width = 0.9,
			min_width = { 40, 0.4 },
			width = nil,
			max_height = { 10, 0.9 },
			min_height = { 5, 0.1 },
			height = nil,
			border = "rounded",
			minimized_border = "none",
			win_options = {
				winblend = 0,
			},
		},
	})
	vim.g._oil_configured = true
end

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

	use("nvim-tree/nvim-web-devicons")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use("christoomey/vim-tmux-navigator")
	use("joshdick/onedark.vim")
	use("folke/tokyonight.nvim")
	use("rakr/vim-one")
	use("junegunn/goyo.vim")
	-- use("spf13/vim-autoclose") -- Replaced with nvim-autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("tomtom/tcomment_vim")
	use("tpope/vim-abolish")
	use("tpope/vim-fugitive")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-unimpaired")
	-- use("tpope/vim-vinegar") -- Replaced by oil.nvim

	-- Oil.nvim - Edit filesystem like a buffer
	use({
		"stevearc/oil.nvim",
	})

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

	-- Enhanced TypeScript support
	use({
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	})

	use({
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({})
		end,
	})

	use("nvimtools/none-ls.nvim")

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
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	})

	-- Git signs in the gutter
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
					map("n", "<leader>hS", gs.stage_buffer)
					map("n", "<leader>hu", gs.undo_stage_hunk)
					map("n", "<leader>hR", gs.reset_buffer)
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end)
					map("n", "<leader>td", gs.toggle_deleted)
				end,
			})
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

-- Ensure core plugins exist before requiring them.
local function ensure_plugins()
	local start_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/"
	local required = {
		"mason.nvim",
		"nvim-lspconfig",
		"nvim-cmp",
		"plenary.nvim",
		"telescope.nvim",
		"lualine.nvim",
	}
	if theme:match("^tokyonight") then
		table.insert(required, "tokyonight.nvim")
	end

	for _, name in ipairs(required) do
		if vim.fn.empty(vim.fn.glob(start_path .. name)) > 0 then
			require("packer").sync()
			print("==================================")
			print("    Plugins are being installed")
			print("    Wait until Packer completes,")
			print("       then restart nvim")
			print("==================================")
			return false
		end
	end

	return true
end

if not ensure_plugins() then
	return
end

setup_oil()

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

-- Oil.nvim keybindings
bind("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
bind("n", "<leader>-", "<CMD>Oil .<CR>", { desc = "Open current working directory" })
bind("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Open oil in floating window" })

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

-- Theme toggle
bind("n", "<leader>tt", function()
	os.execute("toggle-theme")
	vim.cmd("source $MYVIMRC")
end, { desc = "Toggle light/dark theme" })

-- Tmux
--------------------------------------------------------------------------------

vim.g.tmux_navigator_no_mappings = 1
bind("n", "<C-h>", ":TmuxNavigateLeft<cr>", opts)
bind("n", "<C-j>", ":TmuxNavigateDown<cr>", opts)
bind("n", "<C-k>", ":TmuxNavigateUp<cr>", opts)
bind("n", "<C-l>", ":TmuxNavigateRight<cr>", opts)

-- LSP
--------------------------------------------------------------------------------
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local function clamp_location_item(item)
	local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local lnum = tonumber(item.lnum) or 1
	if lnum < 1 then
		lnum = 1
	elseif line_count > 0 and lnum > line_count then
		lnum = line_count
	end
	local line = ""
	if line_count > 0 then
		line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
	end
	local col = tonumber(item.col) or 1
	if col < 1 then
		col = 1
	elseif col > #line + 1 then
		col = #line + 1
	end
	item.bufnr = bufnr
	item.lnum = lnum
	item.col = col
	return item
end

local function safe_location_list(options)
	local items = {}
	for _, item in ipairs(options.items or {}) do
		table.insert(items, clamp_location_item(item))
	end
	if vim.tbl_isempty(items) then
		vim.notify("No locations found", vim.log.levels.INFO)
		return
	end
	if #items == 1 then
		local item = items[1]
		local win = vim.api.nvim_get_current_win()
		vim.cmd("normal! m'")
		vim.bo[item.bufnr].buflisted = true
		vim.api.nvim_win_set_buf(win, item.bufnr)
		pcall(vim.api.nvim_win_set_cursor, win, { item.lnum, item.col - 1 })
		vim._with({ win = win }, function()
			vim.cmd("normal! zv")
		end)
		return
	end
	vim.fn.setqflist({}, " ", { title = options.title or "LSP locations", items = items })
	vim.cmd("botright copen")
end

local function lsp_definition()
	vim.lsp.buf.definition({ on_list = safe_location_list })
end

local function lsp_declaration()
	vim.lsp.buf.declaration({ on_list = safe_location_list })
end

local function lsp_type_definition()
	vim.lsp.buf.type_definition({ on_list = safe_location_list })
end

local function lsp_implementation()
	vim.lsp.buf.implementation({ on_list = safe_location_list })
end

local function lsp_references()
	vim.lsp.buf.references(nil, { on_list = safe_location_list })
end

-- LSP Attach function
local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	bind("n", "gD", lsp_declaration, bufopts)
	bind("n", "gd", lsp_definition, bufopts)
	bind("n", "K", vim.lsp.buf.hover, bufopts)
	bind("n", "gi", lsp_implementation, bufopts)
	bind("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	bind("n", "<leader>D", lsp_type_definition, bufopts)
	bind("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	bind("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	bind("n", "gr", lsp_references, bufopts)
	bind("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end

-- Setup nvim-cmp
local cmp = require("cmp")
local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- Setup nvim-autopairs integration with cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = vim.schedule_wrap(function(fallback)
			if cmp.visible() and has_words_before() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "copilot", group_index = 2 },
		{ name = "nvim_lsp", group_index = 2, keyword_length = 3 },
		{ name = "luasnip", group_index = 2, keyword_length = 2 },
	}, {
		{ name = "buffer", group_index = 2, keyword_length = 3 },
		{ name = "path", group_index = 2 },
	}),
})

-- Setup LSP capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local has_lsp_config = vim.lsp and vim.lsp.config ~= nil and vim.lsp.enable ~= nil
local lspconfig_util = require("lspconfig.util")
local lspconfig = nil
if not has_lsp_config then
	lspconfig = require("lspconfig")
end

local function setup_server(name, config)
	if has_lsp_config then
		vim.lsp.config(name, config)
		vim.lsp.enable(name)
	else
		lspconfig[name].setup(config)
	end
end

local function setup_default_server(name)
	setup_server(name, {
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

local function ensure_path_entry(path)
	if path == "" then
		return
	end
	local expanded = vim.fn.expand(path)
	if vim.fn.isdirectory(expanded) == 1 and not vim.env.PATH:find(expanded, 1, true) then
		vim.env.PATH = expanded .. ":" .. vim.env.PATH
	end
end

local function bundle_cmd(exe, extra_args)
	ensure_path_entry("~/.local/share/mise/shims")
	local bundle = vim.fn.exepath("bundle")
	if bundle ~= "" then
		local cmd = { bundle, "exec", exe }
		if extra_args then
			vim.list_extend(cmd, extra_args)
		end
		return cmd
	end
	if vim.fn.executable(exe) == 1 then
		local cmd = { exe }
		if extra_args then
			vim.list_extend(cmd, extra_args)
		end
		return cmd
	end
	return nil
end

local function set_root(config, markers)
	if has_lsp_config then
		config.root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			local root = vim.fs.root(fname, markers)
			if root then
				on_dir(root)
			end
		end
	else
		config.root_dir = lspconfig_util.root_pattern(unpack(markers))
	end
end

local function cmd_with_root(cmd)
	if not cmd or not has_lsp_config then
		return cmd
	end
	return function(dispatchers, config)
		local cwd = config.root_dir or vim.fn.getcwd()
		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = cwd,
			env = config.cmd_env,
		})
	end
end

local function sorbet_lsp_args(root_dir)
	local args = { "tc", "--lsp", "--disable-watchman", "--no-config", "--dir", "." }
	if not root_dir or root_dir == "" then
		return args
	end
	local config_path = vim.fs.joinpath(root_dir, "sorbet", "config")
	local ok, lines = pcall(vim.fn.readfile, config_path)
	if not ok then
		return args
	end
	for _, line in ipairs(lines) do
		line = vim.trim(line)
		if line ~= "" and not line:match("^#") then
			if not line:match("^%-%-dir=") and not line:match("^%-%-file=") then
				table.insert(args, line)
			end
		end
	end
	return args
end

local function sorbet_rpc_start(dispatchers, config)
	local cwd = config.root_dir or vim.fn.getcwd()
	local cmd = bundle_cmd("srb", sorbet_lsp_args(cwd))
	if not cmd then
		return nil
	end
	return vim.lsp.rpc.start(cmd, dispatchers, {
		cwd = cwd,
		env = config.cmd_env,
	})
end

-- Setup mason-lspconfig with error handling
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
	pcall(mason_lspconfig.setup, {
		ensure_installed = {
			"ts_ls",
			"lua_ls",
			"eslint",
			"jsonls",
			"html",
			"cssls",
			-- "rubocop", -- Use project's bundled version instead
		},
	})
end

-- Core servers (ts_ls handled by typescript-tools below)
setup_server("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

setup_server("eslint", {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
	capabilities = capabilities,
})

setup_default_server("jsonls")
setup_default_server("html")
setup_default_server("cssls")

-- Manually setup servers not handled by mason-lspconfig
if vim.fn.executable("deno") == 1 then
	local deno_config = {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	set_root(deno_config, { "deno.json", "deno.jsonc" })
	setup_server("denols", deno_config)
end

local syntax_tree_cmd = bundle_cmd("stree", { "lsp" })
if syntax_tree_cmd and vim.fn.executable("stree") == 1 then
	local syntax_tree_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = cmd_with_root(syntax_tree_cmd),
	}
	setup_server("syntax_tree", syntax_tree_config)
end

-- Sorbet LSP setup for Ruby type checking
-- Using the system-installed Sorbet instead of Mason's version
if bundle_cmd("srb") then
	local sorbet_config = {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			-- Disable formatting from Sorbet (let rubocop handle it)
			client.server_capabilities.documentFormattingProvider = false
			-- Additional Sorbet-specific keybindings
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			bind("n", "<leader>st", lsp_type_definition, bufopts)
			bind("n", "<leader>si", lsp_implementation, bufopts)
		-- Sorbet-specific commands
		bind("n", "<leader>ss", "<cmd>lua vim.lsp.buf.signature_help()<cr>", bufopts)

			-- Filter diagnostics to only show warnings and errors
			local namespace = vim.lsp.diagnostic.get_namespace(client.id)
			vim.diagnostic.config({
				severity_sort = true,
				virtual_text = {
					severity = { min = vim.diagnostic.severity.WARN },
				},
				signs = {
					severity = { min = vim.diagnostic.severity.WARN },
				},
				underline = {
					severity = { min = vim.diagnostic.severity.WARN },
				},
			}, namespace)
		end,
		capabilities = capabilities,
		cmd = sorbet_rpc_start,
		filetypes = { "ruby" },
		init_options = {
			highlightUntyped = false, -- Don't highlight untyped code as it's too noisy
		},
		settings = {
			sorbet = {
				-- Only show warnings and errors
				diagnosticSeverityOverrides = {
					["5002"] = "Warning", -- Untyped code
					["5023"] = "Warning", -- Untyped argument
				},
			},
		},
	}
	set_root(sorbet_config, { "sorbet", "Gemfile", ".git" })
	setup_server("sorbet", sorbet_config)
end

-- Ruby LSP for general Ruby support (syntax, formatting, etc.)
-- This works alongside Sorbet for better Ruby development experience
local ruby_lsp_cmd = bundle_cmd("ruby-lsp")
if ruby_lsp_cmd then
	local ruby_lsp_config = {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			-- Let ruby-lsp handle formatting
			client.server_capabilities.documentFormattingProvider = true
		end,
		capabilities = capabilities,
		cmd = cmd_with_root(ruby_lsp_cmd),
		filetypes = { "ruby" },
		init_options = {
			formatter = "auto",
		},
		single_file_support = true,
	}
	set_root(ruby_lsp_config, { "Gemfile", ".git" })
	setup_server("ruby_lsp", ruby_lsp_config)
end

-- TypeScript/JavaScript LSP setup with typescript-tools.nvim
-- typescript-tools provides better performance and more features than ts_ls
local typescript_tools_ok, typescript_tools = pcall(require, "typescript-tools")
if typescript_tools_ok then
	typescript_tools.setup({
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			-- Additional TypeScript-specific keybindings
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			bind("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", bufopts)
			bind("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", bufopts)
			bind("n", "<leader>tr", "<cmd>TSToolsRemoveUnused<cr>", bufopts)
			bind("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", bufopts)
			bind("n", "<leader>ta", "<cmd>TSToolsAddMissingImports<cr>", bufopts)
			bind("n", "<leader>ti", "<cmd>TSToolsFileReferences<cr>", bufopts)
		end,
		capabilities = capabilities,
		settings = {
			-- Enable all available settings for better TypeScript support
			tsserver_path = nil, -- auto-detect
			tsserver_plugins = {},
			tsserver_max_memory = "auto",
			tsserver_format_options = {},
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
				quotePreference = "auto",
			},
			tsserver_locale = "en",
			complete_function_calls = true,
			include_completions_with_insert_text = true,
			code_lens = "all",
			disable_member_code_lens = false,
			jsx_close_tag = {
				enable = true,
				filetypes = { "javascriptreact", "typescriptreact" },
			},
		},
	})
else
	-- Fallback to regular ts_ls if typescript-tools is not available
	local ts_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		single_file_support = true,
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
				format = {
					indentSize = 2,
					tabSize = 2,
					convertTabsToSpaces = true,
					trimTrailingWhitespace = true,
					insertFinalNewline = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
				format = {
					indentSize = 2,
					tabSize = 2,
					convertTabsToSpaces = true,
					trimTrailingWhitespace = true,
					insertFinalNewline = true,
				},
			},
			completions = {
				completeFunctionCalls = true,
			},
		},
	}
	set_root(ts_config, { "package.json", "tsconfig.json", "jsconfig.json", ".git" })
	setup_server("ts_ls", ts_config)
end

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	float = {
		source = "always",
		border = "rounded",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Show diagnostics in hover window
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- Setup null-ls/none-ls
local null_ls_ok, null_ls = pcall(require, "null-ls")
if null_ls_ok then
	local lsp_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	local lsp_formatting = function(bufnr)
		vim.lsp.buf.format({
			bufnr = bufnr,
			filter = function(client)
				return client.name == "null-ls"
			end,
		})
	end

	local null_opts = {
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if ft == "ruby" and vim.env.NVIM_FORMAT_RUBY ~= "1" then
					return
				end
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
	}

	local sources = {}

	if null_ls.builtins then
		-- Commenting out eslint_d sources since it's not installed
		-- Uncomment these if you install eslint_d via: npm install -g eslint_d
		
		-- Code actions
		-- if null_ls.builtins.code_actions and null_ls.builtins.code_actions.eslint_d then
		-- 	table.insert(
		-- 		sources,
		-- 		null_ls.builtins.code_actions.eslint_d.with({
		-- 			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		-- 		})
		-- 	)
		-- end

		-- Diagnostics
		-- if null_ls.builtins.diagnostics and null_ls.builtins.diagnostics.eslint_d then
		-- 	table.insert(
		-- 		sources,
		-- 		null_ls.builtins.diagnostics.eslint_d.with({
		-- 			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		-- 		})
		-- 	)
		-- end

		-- Formatting
		if null_ls.builtins.formatting then
			-- if null_ls.builtins.formatting.eslint_d then
			-- 	table.insert(
			-- 		sources,
			-- 		null_ls.builtins.formatting.eslint_d.with({
			-- 			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			-- 		})
			-- 	)
			-- end

			if null_ls.builtins.formatting.prettierd then
				table.insert(
					sources,
					null_ls.builtins.formatting.prettierd.with({
						condition = function()
							return vim.fn.executable("prettierd") == 1
						end,
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"css",
							"scss",
							"less",
							"html",
							"json",
							"jsonc",
							"yaml",
							"markdown",
							"markdown.mdx",
							"graphql",
							"handlebars",
						},
					})
				)
			end

			if null_ls.builtins.formatting.stylua then
				table.insert(sources, null_ls.builtins.formatting.stylua)
			end

			-- Ruby formatting with rubocop (if available in project)
			if null_ls.builtins.formatting.rubocop then
				table.insert(sources, null_ls.builtins.formatting.rubocop.with({
					command = "bundle",
					args = {
						"exec",
						"rubocop",
						"--force-exclusion",
						"--autocorrect",
						"--format",
						"quiet",
						"--stderr",
						"--stdin",
						"$FILENAME",
					},
					condition = function(utils)
						return utils.root_has_file({ ".rubocop.yml", "Gemfile" }) and vim.fn.executable("bundle") == 1
					end,
				}))
			end
			
			-- Add custom stree formatter since it's not a built-in
			local h = require("null-ls.helpers")
			local methods = require("null-ls.methods")
			local FORMATTING = methods.internal.FORMATTING
			
			local stree_formatter = h.make_builtin({
				name = "stree",
				meta = {
					url = "https://github.com/ruby-syntax-tree/syntax_tree",
					description = "Fast Ruby formatter",
				},
				method = FORMATTING,
				filetypes = { "ruby" },
				generator_opts = {
					command = "stree",
					args = { "format" },
					to_stdin = true,
				},
				factory = h.formatter_factory,
			})
			
			-- Check if stree is available before adding it
			if vim.fn.executable("stree") == 1 then
				table.insert(sources, stree_formatter)
			end

			-- Rubocop for diagnostics
			if null_ls.builtins.diagnostics and null_ls.builtins.diagnostics.rubocop then
				table.insert(sources, null_ls.builtins.diagnostics.rubocop.with({
					command = "bundle",
					args = { "exec", "rubocop", "--force-exclusion", "--format", "json", "--stdin", "$FILENAME" },
					condition = function(utils)
						return utils.root_has_file({ ".rubocop.yml", "Gemfile" }) and vim.fn.executable("bundle") == 1
					end,
				}))
			end

			if null_ls.builtins.formatting.shfmt then
				table.insert(sources, null_ls.builtins.formatting.shfmt)
			end
		end
	end

	null_ls.setup({
		root_dir = require("null-ls.utils").root_pattern(".git", "pnpm-workspace.yaml", "Gemfile"),
		on_attach = function(client, bufnr)
			null_opts.on_attach(client, bufnr)
		end,
		sources = sources,
	})
end

-- Treesitter
--------------------------------------------------------------------------------
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if status_ok then
	configs.setup({
		ensure_installed = { "typescript", "tsx", "javascript", "lua", "json", "ruby", "html", "css" },
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	})
end

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

-- Additional diagnostic keybindings
bind("n", "[d", vim.diagnostic.goto_prev, opts)
bind("n", "]d", vim.diagnostic.goto_next, opts)
bind("n", "<leader>e", vim.diagnostic.open_float, opts)
bind("n", "<leader>q", vim.diagnostic.setloclist, opts)
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

-- Fix Oil.nvim keybinding conflicts
autocmd("FileType", {
	group = augroup,
	pattern = "oil",
	callback = function()
		-- Restore Telescope Ctrl-P in Oil buffers
		vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { buffer = true, silent = true })
		-- Ensure tmux navigation works in Oil buffers
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { buffer = true, silent = true })
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { buffer = true, silent = true })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { buffer = true, silent = true })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { buffer = true, silent = true })
	end,
})
