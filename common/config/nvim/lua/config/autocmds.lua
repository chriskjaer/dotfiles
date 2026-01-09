local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', { clear = true })

autocmd('FileType', {
  group = augroup,
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'harpoon', 'null-ls-info' },
  command = 'nnoremap <buffer> q <cmd>quit<cr>',
})

autocmd('FileType', {
  group = augroup,
  pattern = { 'text' },
  command = 'setlocal textwidth=80',
})

autocmd('FileType', {
  group = augroup,
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = ''
    vim.opt_local.colorcolumn = ''
    vim.opt_local.textwidth = 120
    vim.opt_local.formatoptions:remove({ 't' })

    local match_id = vim.b.markdown_overlength_match_id
    if match_id then
      pcall(vim.fn.matchdelete, match_id)
    end

    vim.api.nvim_set_hl(0, 'MarkdownOverLength', { link = 'ColorColumn' })
    vim.b.markdown_overlength_match_id = vim.fn.matchadd('MarkdownOverLength', '\\%>120v.')
  end,
})

autocmd('FileType', {
  group = augroup,
  pattern = { 'ruby' },
  command = 'setlocal colorcolumn=120',
})

autocmd('FileType', {
  group = augroup,
  pattern = { 'javascript', 'typescript' },
  callback = function()
    vim.keymap.set('n', '<Leader>cl', 'yiwoconsole.log(\'<C-r>"\', <C-r>")<esc>^', { buffer = true })
  end,
})

autocmd('FileType', {
  group = augroup,
  pattern = 'oil',
  callback = function()
    vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { buffer = true, silent = true })
    vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<cr>', { buffer = true, silent = true })
    vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<cr>', { buffer = true, silent = true })
    vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<cr>', { buffer = true, silent = true })
    vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<cr>', { buffer = true, silent = true })
  end,
})
