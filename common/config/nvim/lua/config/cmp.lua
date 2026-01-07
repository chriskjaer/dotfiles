local M = {}

function M.setup()
  local ok, cmp = pcall(require, 'cmp')
  if not ok then
    return
  end
  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if luasnip_ok then
    pcall(function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end)
  end

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
  end

  local cmp_autopairs_ok, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
  if cmp_autopairs_ok then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        if luasnip_ok then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'copilot', group_index = 2 },
      { name = 'nvim_lsp', group_index = 2, keyword_length = 3 },
      { name = 'luasnip', group_index = 2, keyword_length = 2 },
    }, {
      { name = 'buffer', group_index = 2, keyword_length = 3 },
      { name = 'path', group_index = 2 },
    }),
  })
end

return M
