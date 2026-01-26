local M = {}

function M.setup()
  if vim.g._oil_configured then
    return
  end
  local ok, oil = pcall(require, 'oil')
  if not ok then
    return
  end
  oil.setup({
    default_file_explorer = true,
    columns = {
      'icon',
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-t>'] = 'actions.select_tab',
      ['P'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-r>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, _bufnr)
        return vim.startswith(name, '.')
      end,
      is_always_hidden = function(_name, _bufnr)
        return false
      end,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      override = function(conf)
        return conf
      end,
    },
    preview = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      minimized_border = 'none',
      win_options = {
        winblend = 0,
      },
    },
  })
  vim.g._oil_configured = true
end

return M
