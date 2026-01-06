local M = {}

local function get_root()
  local root = vim.fs.root(0, { '.git', 'Gemfile', 'package.json' })
  if not root or root == '' then
    root = vim.fn.getcwd()
  end
  return root
end

local function state_path()
  return vim.fn.stdpath('data') .. '/local-config.json'
end

local function read_state()
  local path = state_path()
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines then
    return {}
  end
  local decoded = vim.fn.json_decode(table.concat(lines, '\n'))
  if type(decoded) ~= 'table' then
    return {}
  end
  return decoded
end

local function write_state(state)
  local path = state_path()
  local encoded = vim.fn.json_encode(state)
  vim.fn.writefile({ encoded }, path)
end

local function is_allowed(state, path)
  return state[path] == true
end

local function allow_path(state, path)
  state[path] = true
  write_state(state)
end

function M.load()
  local root = get_root()
  local local_file = vim.fs.joinpath(root, '.nvim.lua')
  if vim.fn.filereadable(local_file) ~= 1 then
    return
  end

  local state = read_state()
  if is_allowed(state, local_file) then
    dofile(local_file)
    return
  end

  if vim.fn.has('vim_starting') == 0 or vim.fn.has('nvim-0.10') == 0 then
    return
  end
  if vim.fn.has('nvim') == 0 then
    return
  end
  if vim.fn.has('gui_running') == 0 and vim.env.NVIM_HEADLESS == '1' then
    return
  end

  local choice = vim.fn.confirm('Load local config?\n' .. local_file, '&Once\n&Always\n&No', 3)
  if choice == 1 then
    dofile(local_file)
  elseif choice == 2 then
    allow_path(state, local_file)
    dofile(local_file)
  end
end

return M
