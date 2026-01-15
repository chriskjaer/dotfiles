local M = {}

local function ensure_path_entry(path)
  if path == '' then
    return
  end
  local expanded = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded) == 1 and not vim.env.PATH:find(expanded, 1, true) then
    vim.env.PATH = expanded .. ':' .. vim.env.PATH
  end
end

local function is_ruby_file(fname)
  if vim.filetype and vim.filetype.match then
    local ft = vim.filetype.match({ filename = fname })
    if ft and ft ~= '' then
      return ft == 'ruby'
    end
  end
  local ext = fname:match('%.([^.]+)$')
  return ext == 'rb' or ext == 'rbi' or ext == 'rake' or ext == 'ru' or ext == 'gemspec'
end

function M.setup()
  local null_ls_ok, null_ls = pcall(require, 'null-ls')
  if not null_ls_ok then
    return
  end

  ensure_path_entry('~/.local/share/mise/shims')
  local root_pattern = require('null-ls.utils').root_pattern

  local lsp_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

  local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
      bufnr = bufnr,
      filter = function(client)
        return client.name == 'null-ls'
      end,
    })
  end

  local null_opts = {
    on_attach = function(client, bufnr)
      if client.supports_method('textDocument/formatting') then
        local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        if ft == 'ruby' and vim.env.NVIM_FORMAT_RUBY == '0' then
          return
        end
        vim.api.nvim_clear_autocmds({ group = lsp_augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
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
    if null_ls.builtins.formatting then
      if null_ls.builtins.formatting.prettierd then
        table.insert(
          sources,
          null_ls.builtins.formatting.prettierd.with({
            condition = function()
              return vim.fn.executable('prettierd') == 1
            end,
            filetypes = {
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
              'vue',
              'css',
              'scss',
              'less',
              'html',
              'json',
              'jsonc',
              'yaml',
              'markdown',
              'markdown.mdx',
              'graphql',
              'handlebars',
            },
          })
        )
      end

      if null_ls.builtins.formatting.stylua then
        table.insert(sources, null_ls.builtins.formatting.stylua)
      end

      local h = require('null-ls.helpers')
      local methods = require('null-ls.methods')
      local FORMATTING = methods.internal.FORMATTING

      local stree_bundle_formatter = h.make_builtin({
        name = 'stree_bundle',
        meta = {
          url = 'https://github.com/ruby-syntax-tree/syntax_tree',
          description = 'Fast Ruby formatter',
        },
        method = FORMATTING,
        filetypes = { 'ruby' },
        generator_opts = {
          command = 'bundle',
          args = { 'exec', 'stree', 'format' },
          to_stdin = true,
        },
        condition = function(utils)
          return utils.root_has_file({ 'Gemfile' }) and vim.fn.executable('bundle') == 1
        end,
        factory = h.formatter_factory,
      })

      local stree_global_formatter = h.make_builtin({
        name = 'stree',
        meta = {
          url = 'https://github.com/ruby-syntax-tree/syntax_tree',
          description = 'Fast Ruby formatter',
        },
        method = FORMATTING,
        filetypes = { 'ruby' },
        generator_opts = {
          command = 'stree',
          args = { 'format' },
          to_stdin = true,
        },
        condition = function(utils)
          return not utils.root_has_file({ 'Gemfile' }) and vim.fn.executable('stree') == 1
        end,
        factory = h.formatter_factory,
      })

      table.insert(sources, stree_bundle_formatter)
      table.insert(sources, stree_global_formatter)

      if null_ls.builtins.diagnostics and null_ls.builtins.diagnostics.rubocop then
        table.insert(
          sources,
          null_ls.builtins.diagnostics.rubocop.with({
            command = 'bundle',
            args = { 'exec', 'rubocop', '--force-exclusion', '--format', 'json', '--stdin', '$FILENAME' },
            condition = function(utils)
              return utils.root_has_file({ '.rubocop.yml', 'Gemfile' }) and vim.fn.executable('bundle') == 1
            end,
          })
        )
      end

      if null_ls.builtins.formatting.shfmt then
        table.insert(sources, null_ls.builtins.formatting.shfmt)
      end
    end
  end

  null_ls.setup({
    root_dir = function(fname)
      if is_ruby_file(fname) then
        local ruby_root = root_pattern('Gemfile', '.rubocop.yml', 'sorbet')(fname)
        if ruby_root then
          return ruby_root
        end
      end
      return root_pattern('.git', 'pnpm-workspace.yaml')(fname)
    end,
    on_attach = function(client, bufnr)
      null_opts.on_attach(client, bufnr)
    end,
    sources = sources,
  })
end

return M
