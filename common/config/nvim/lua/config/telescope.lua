local M = {}

function M.setup()
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    return
  end
  telescope.setup({
    defaults = {
      layout_config = {
        prompt_position = 'top',
      },
      sorting_strategy = 'ascending',
      selection_caret = '> ',
    },
  })
end

return M
