require("plugins")

-- Keybindings
--------------------------------------------------------------------------------

local key = vim.keymap

key.set("n", "<leader><leader>", "<c-^>") -- Switch between the last two files

local printError = vim.api.nvim_err_writeln
key.set("n", "<Left>", function()
	printError("Use h")
end)
key.set("n", "<Right>", function()
	printError("Use l")
end)
key.set("n", "<Up>", function()
	printError("Use k")
end)
key.set("n", "<Down>", function()
	printError("Use j")
end)

-- Quicker window movement
key.set("n", "<C-h>", "<C-w>h")
key.set("n", "<C-j>", "<C-w>j")
key.set("n", "<C-k>", "<C-w>k")
key.set("n", "<C-l>", "<C-w>l")

-- Reselect visual block after indent/outdent
key.set("v", "<", "<gv")
key.set("v", ">", ">gv")

-- Fast saving
key.set("n", "<leader>w", "<cmd>w<cr>")

-- LSP
--------------------------------------------------------------------------------
local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.setup()

require("lspconfig").sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.diagnostic.config({ virtual_text = true })

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})

null_ls.setup({
	root_dir = require("null-ls.utils").root_pattern(".git", "pnpm-workspace.yaml"),

	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		key.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
		key.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		key.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
		key.set("n", "gr", vim.lsp.buf.references, bufopts)
		key.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, bufopts)
	end,

	sources = {
		null_ls.builtins.formatting.black,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "html", "json", "yaml", "markdown" },
		}),
	},
})

-- Tresitter
--------------------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
	ensure_install = { "typescript", "lua", "json" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- Telescope
--------------------------------------------------------------------------------
local builtin = require("telescope.builtin")
local opts = { silent = true, noremap = true }
key.set("n", "<leader>ff", builtin.find_files, opts)
key.set("n", "<C-p>", builtin.find_files, opts)
key.set("n", "<leader>fg", builtin.live_grep, opts)
key.set("n", "<leader>fb", builtin.buffers, opts)
key.set("n", "<leader>fh", builtin.help_tags, opts)

-- Lualine
--------------------------------------------------------------------------------
require("lualine").setup()
