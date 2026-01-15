local M = {}

function M.setup()
  local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not status_ok then
    return
  end
  configs.setup({
    ensure_installed = { 'lua', 'ruby', 'vim', 'vimdoc', 'query' },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  })
end

return M
