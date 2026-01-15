local bind = vim.keymap.set

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
  local line = ''
  if line_count > 0 then
    line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ''
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
    vim.notify('No locations found', vim.log.levels.INFO)
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
      vim.cmd('normal! zv')
    end)
    return
  end
  vim.fn.setqflist({}, ' ', { title = options.title or 'LSP locations', items = items })
  vim.cmd('botright copen')
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

local function toggle_inlay_hints()
  if not (vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable) then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled
  if vim.lsp.inlay_hint.is_enabled then
    enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  else
    vim.lsp.inlay_hint(bufnr, nil)
  end
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  bind('n', 'gD', lsp_declaration, bufopts)
  bind('n', 'gd', lsp_definition, bufopts)
  bind('n', 'K', vim.lsp.buf.hover, bufopts)
  bind('n', 'gi', lsp_implementation, bufopts)
  bind('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  bind('n', '<leader>D', lsp_type_definition, bufopts)
  bind('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  bind('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  bind('n', 'gr', lsp_references, bufopts)
  bind('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
  if client.supports_method('textDocument/inlayHint') then
    bind('n', '<leader>ih', toggle_inlay_hints, bufopts)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local cmp_caps_ok, cmp_caps = pcall(require, 'cmp_nvim_lsp')
if cmp_caps_ok then
  capabilities = cmp_caps.default_capabilities(capabilities)
end

local has_lsp_config = vim.lsp and vim.lsp.config ~= nil and vim.lsp.enable ~= nil
local lspconfig_util = nil
local lspconfig = nil
if not has_lsp_config then
  local ok
  ok, lspconfig = pcall(require, 'lspconfig')
  if ok then
    lspconfig_util = require('lspconfig.util')
  end
else
  local ok
  ok, lspconfig_util = pcall(require, 'lspconfig.util')
  if not ok then
    lspconfig_util = nil
  end
end

local function setup_server(name, config)
  if has_lsp_config then
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  elseif lspconfig then
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
  if path == '' then
    return
  end
  local expanded = vim.fn.expand(path)
  if vim.fn.isdirectory(expanded) == 1 and not vim.env.PATH:find(expanded, 1, true) then
    vim.env.PATH = expanded .. ':' .. vim.env.PATH
  end
end

local function bundle_cmd(exe, extra_args)
  ensure_path_entry('~/.local/share/mise/shims')
  local bundle = vim.fn.exepath('bundle')
  if bundle ~= '' then
    local cmd = { bundle, 'exec', exe }
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
  elseif lspconfig_util then
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
  local args = { 'tc', '--lsp', '--disable-watchman', '--no-config', '--dir', '.' }
  if not root_dir or root_dir == '' then
    return args
  end
  local config_path = vim.fs.joinpath(root_dir, 'sorbet', 'config')
  local ok, lines = pcall(vim.fn.readfile, config_path)
  if not ok then
    return args
  end
  for _, line in ipairs(lines) do
    line = vim.trim(line)
    if line ~= '' and not line:match('^#') then
      if line:match('^%-%-') then
        if not line:match('^%-%-dir') and not line:match('^%-%-file') then
          table.insert(args, line)
        end
      end
    end
  end
  return args
end

local function sorbet_rpc_start(dispatchers, config)
  local cwd = config.root_dir or vim.fn.getcwd()
  local cmd = bundle_cmd('srb', sorbet_lsp_args(cwd))
  if not cmd then
    return nil
  end
  return vim.lsp.rpc.start(cmd, dispatchers, {
    cwd = cwd,
    env = config.cmd_env,
  })
end

local function bundle_has_gem(root_dir, gem_name)
  if not root_dir or root_dir == '' then
    return false
  end
  local lockfile = vim.fs.joinpath(root_dir, 'Gemfile.lock')
  local ok, lines = pcall(vim.fn.readfile, lockfile)
  local needle = vim.pesc(gem_name)
  if ok then
    for _, line in ipairs(lines) do
      if line:match('^' .. needle .. ' %(') then
        return true
      end
    end
  end
  local gemfile = vim.fs.joinpath(root_dir, 'Gemfile')
  ok, lines = pcall(vim.fn.readfile, gemfile)
  if ok then
    for _, line in ipairs(lines) do
      if line:match('gem%s+[\'"]' .. needle .. '[\'"]') then
        return true
      end
    end
  end
  return false
end

local function ruby_lsp_cmd_for_root(root_dir)
  ensure_path_entry('~/.local/share/mise/shims')
  if root_dir and root_dir ~= '' and bundle_has_gem(root_dir, 'ruby-lsp') then
    return bundle_cmd('ruby-lsp')
  end
  if vim.fn.executable('ruby-lsp') == 1 then
    return { 'ruby-lsp' }
  end
  if root_dir and root_dir ~= '' then
    local composed_gemfile = vim.fs.joinpath(root_dir, '.ruby-lsp', 'Gemfile')
    if vim.fn.filereadable(composed_gemfile) == 1 then
      local cmd = bundle_cmd('ruby-lsp')
      if cmd then
        return cmd, { BUNDLE_GEMFILE = composed_gemfile }
      end
    end
  end
  return nil
end

local function ruby_lsp_rpc_start(dispatchers, config)
  local cwd = config.root_dir or vim.fn.getcwd()
  local cmd, extra_env = ruby_lsp_cmd_for_root(cwd)
  if not cmd then
    return nil
  end
  local env = config.cmd_env
  if extra_env then
    if env then
      env = vim.tbl_extend('force', env, extra_env)
    else
      env = extra_env
    end
  end
  return vim.lsp.rpc.start(cmd, dispatchers, {
    cwd = cwd,
    env = env,
  })
end

local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
  mason.setup({
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if mason_lspconfig_ok then
  pcall(mason_lspconfig.setup, {
    ensure_installed = {
      'ts_ls',
      'lua_ls',
      'eslint',
      'jsonls',
      'html',
      'cssls',
    },
    automatic_enable = {
      exclude = {
        'rubocop',
      },
    },
  })
end

setup_server('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

setup_server('eslint', {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
  capabilities = capabilities,
})

setup_default_server('jsonls')
setup_default_server('html')
setup_default_server('cssls')

if vim.fn.executable('deno') == 1 then
  local deno_config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  set_root(deno_config, { 'deno.json', 'deno.jsonc' })
  setup_server('denols', deno_config)
end

local syntax_tree_cmd = bundle_cmd('stree', { 'lsp' })
if syntax_tree_cmd and vim.fn.executable('stree') == 1 then
  local syntax_tree_config = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = cmd_with_root(syntax_tree_cmd),
  }
  setup_server('syntax_tree', syntax_tree_config)
end

if bundle_cmd('srb') then
  local sorbet_config = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      bind('n', '<leader>st', lsp_type_definition, bufopts)
      bind('n', '<leader>si', lsp_implementation, bufopts)
      bind('n', '<leader>ss', '<cmd>lua vim.lsp.buf.signature_help()<cr>', bufopts)

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
    filetypes = { 'ruby' },
    init_options = {
      highlightUntyped = false,
    },
    settings = {
      sorbet = {
        diagnosticSeverityOverrides = {
          ['5002'] = 'Warning',
          ['5023'] = 'Warning',
        },
      },
    },
  }
  set_root(sorbet_config, { 'sorbet', 'Gemfile', '.git' })
  setup_server('sorbet', sorbet_config)
end

if vim.fn.executable('ruby-lsp') == 1 or vim.fn.executable('bundle') == 1 then
  local ruby_lsp_config = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
    end,
    capabilities = capabilities,
    cmd = ruby_lsp_rpc_start,
    filetypes = { 'ruby' },
    init_options = {
      formatter = 'auto',
      indexing = {
        excluded_patterns = {
          'tmp/**',
          'log/**',
          'coverage/**',
          'node_modules/**',
          'storage/**',
          'public/assets/**',
          'vendor/**',
        },
      },
    },
    single_file_support = true,
  }
  set_root(ruby_lsp_config, { 'Gemfile', '.git' })
  setup_server('ruby_lsp', ruby_lsp_config)
end

local typescript_tools_ok, typescript_tools = pcall(require, 'typescript-tools')
if typescript_tools_ok then
  typescript_tools.setup({
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      bind('n', '<leader>to', '<cmd>TSToolsOrganizeImports<cr>', bufopts)
      bind('n', '<leader>ts', '<cmd>TSToolsSortImports<cr>', bufopts)
      bind('n', '<leader>tr', '<cmd>TSToolsRemoveUnused<cr>', bufopts)
      bind('n', '<leader>tf', '<cmd>TSToolsFixAll<cr>', bufopts)
      bind('n', '<leader>ta', '<cmd>TSToolsAddMissingImports<cr>', bufopts)
      bind('n', '<leader>ti', '<cmd>TSToolsFileReferences<cr>', bufopts)
    end,
    capabilities = capabilities,
    settings = {
      tsserver_path = nil,
      tsserver_plugins = {},
      tsserver_max_memory = 'auto',
      tsserver_format_options = {},
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        quotePreference = 'auto',
      },
      tsserver_locale = 'en',
      complete_function_calls = true,
      include_completions_with_insert_text = true,
      code_lens = 'all',
      disable_member_code_lens = false,
      jsx_close_tag = {
        enable = true,
        filetypes = { 'javascriptreact', 'typescriptreact' },
      },
    },
  })
else
  local ts_config = {
    on_attach = on_attach,
    capabilities = capabilities,
    single_file_support = true,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
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
          includeInlayParameterNameHints = 'all',
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
  set_root(ts_config, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' })
  setup_server('ts_ls', ts_config)
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = 'if_many',
  },
  float = {
    source = 'always',
    border = 'rounded',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})
