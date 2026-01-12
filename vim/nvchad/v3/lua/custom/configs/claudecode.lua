local M = {}

M.opts = {
  focus_after_send = true,
  terminal = {
    provider = "native",
    split_width_percentage = 0.35,
  },
  diff_opts = {
    auto_close_on_accept = true, -- Close diff windows after accepting
    vertical_split = true, -- Use vertical splits for diffs
    open_in_current_tab = false, -- Don't create new tabs
    keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
  },
}

M.config = function()
  local claude_term_view = nil

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    pattern = "term://*claude*",
    callback = function()
      claude_term_view = vim.fn.winsaveview()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    pattern = "term://*claude*",
    callback = function()
      vim.schedule(function()
        vim.cmd("stopinsert")
        if claude_term_view then
          vim.fn.winrestview(claude_term_view)
        end
      end)
    end,
  })
end

return M
