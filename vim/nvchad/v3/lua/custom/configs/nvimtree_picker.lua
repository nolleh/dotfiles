local M = {}

local picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

local function is_excluded(buf)
  local exclude = require("nvim-tree.config").g.actions.open_file.window_picker.exclude
  for option, values in pairs(exclude) do
    local ok, value = pcall(vim.api.nvim_get_option_value, option, { buf = buf })
    if ok and vim.tbl_contains(values, value) then
      return true
    end
  end
  return false
end

local function is_candidate(win)
  local config = vim.api.nvim_win_get_config(win)
  if config.relative ~= "" or not config.focusable or config.hide or config.external then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  return not require("nvim-tree.api").tree.is_tree_buf(buf) and not is_excluded(buf)
end

local function candidates()
  return vim.tbl_filter(is_candidate, vim.api.nvim_tabpage_list_wins(0))
end

local function create_editor_window()
  local buf = vim.api.nvim_create_buf(true, false)
  return vim.api.nvim_open_win(buf, false, {
    split = "right",
    win = vim.api.nvim_get_current_win(),
  })
end

local function choose_window(windows)
  if #windows > #picker_chars then
    vim.notify("Too many windows for the NvimTree window picker", vim.log.levels.ERROR)
    return nil
  end

  local previous_laststatus = vim.o.laststatus
  local saved = {}
  local choices = {}
  vim.o.laststatus = 2

  for index, win in ipairs(windows) do
    local char = picker_chars:sub(index, index)
    saved[win] = {
      statusline = vim.api.nvim_get_option_value("statusline", { win = win }),
      winhl = vim.api.nvim_get_option_value("winhl", { win = win }),
    }
    choices[char] = win
    vim.api.nvim_set_option_value("statusline", "%=" .. char .. "%=", { win = win })
    vim.api.nvim_set_option_value(
      "winhl",
      "StatusLine:NvimTreeWindowPicker,StatusLineNC:NvimTreeWindowPicker",
      { win = win }
    )
  end

  vim.cmd("redraw")
  local ok, char = pcall(vim.fn.getcharstr)

  for win, options in pairs(saved) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value("statusline", options.statusline, { win = win })
      vim.api.nvim_set_option_value("winhl", options.winhl, { win = win })
    end
  end
  vim.o.laststatus = previous_laststatus
  vim.cmd("redrawstatus")

  if not ok then
    return nil
  end
  return choices[char:upper()]
end

function M.pick()
  local windows = candidates()
  if #windows == 0 then
    return create_editor_window()
  end
  if #windows == 1 then
    return windows[1]
  end
  return choose_window(windows)
end

return M
