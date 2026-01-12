local map = vim.keymap.set

map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

local claude_term_view = nil

vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  pattern = "term://*cluade*",
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

-- declared in NvChadV2
map("n", "<leader>cc", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local config = require("ibl.config").get_config(bufnr)
  local scope = require("ibl.scope").get(bufnr, config)
  if scope then
    local row, column = scope:start()
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row + 1, column })
  end
end, { desc = "Jump to current context" })

--
map("n", "<tab>", "")
map("n", "<S-tab>", "")

map("n", "<C-p>", ":MarkdownPreviewToggle<CR>")
map("n", "<leader><leader>r", ":Jaq<CR>")
map("n", "<leader>.z", ":ZoomToggle<CR>")
map("n", "<leader>mm", ":MinimapToggle<CR>")
map("n", "<leader>cd", ":cd %:h<CR>:pwd<CR>")
map("n", "<leader>c-", ":cd -<CR>")
map("n", "<leader>pwd", function()
  vim.fn.expand("%:p")
end)

map("n", "tn", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })

map("n", "tp", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto prev buffer" })

-- lsp
map("n", "gv", ":vsplit | lua vim.lsp.buf.definition()<CR>", { desc = "vertical split lsp definition" })
map("n", "gs", ":split | lua vim.lsp.buf.definition()<CR>", { desc = "split lsp definition" })

-- lspsaga
map("n", "<leader>lra", "<cmd> Lspsaga rename <CR>", { desc = "Lspsaga rename" })
map("n", "<leader>lol", "<cmd> Lspsaga outline <CR>", { desc = "Lspsaga outline" })
map("n", "<leader>lci", "<cmd> Lspsaga incoming_calls <CR>", { desc = "Lspsaga incoming calls" })
map("n", "<leader>lco", "<cmd> Lspsaga outgoing_calls <CR>", { desc = "Lspsaga outgoing calls" })
map("n", "<leader>lca", "<cmd> Lspsaga code_action <CR>", { desc = "Lspsaga code action" })
map("n", "<leader>lpd", "<cmd> Lspsaga peek_definition <CR>", { desc = "Lspsaga peek definition" })
map("n", "<leader>lpt", "<cmd> Lspsaga peek_type_definition <CR>", { desc = "Lspsaga peek type definition" })
map("n", "<leader>l[e", "<cmd> Lspsaga diagnostic_jump_prev <CR>", { desc = "Lspsaga diagnostic jump prev" })
map("n", "<leader>l]e", "<cmd> Lspsaga diagnostic_jump_next <CR>", { desc = "Lspsaga diagnostic jump next" })
map("n", "<leader>lf", "<cmd> Lspsaga finder <CR>", { desc = "Lspsaga finder" })
map("n", "<leader>lk", "<cmd> Lspsaga hover_doc <CR>", { desc = "Lspsaga hover doc" })
map("n", "<leader>lK", "<cmd> Lspsaga hover_doc ++keep <CR>", { desc = "Lspsaga hover doc keep" })

-- git
map("n", "<leader>cb", "<cmd> Telescope git_bcommits <CR>", { desc = "Git commits on current buffer" })

map(
  "n",
  "<leader>gl",
  "<cmd> Jaq float git log --all --graph --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset' --date=format-local:'%Y-%m-%d %H:%M (%a)' <CR>",
  { desc = "Git graph with pretty tag" }
)

--map("n","<leader>cl",
--   function()
--     require("telescope.builtin").git_commits({
--       -- git_command = { "git", "log", "--pretty=oneline", "--graph", "--decorate", "--abbrev-commit", "--", "." },
--       git_command = { "git", "log", "--all", "--graph", "--pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset'", "--date=format-local:'%Y-%m-%d %H:%M (%a)'" }
--     })
--   end,
--   "Git commit log with graph",
-- },

map("n", "<leader>ax", ":%bd | e# | bd# | :NvimTreeToggle<CR>", { desc = "close all buf but current" })

-- OmniSharp specific mappings - only when OmniSharp is attached
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "omnisharp" then
      local bufnr = args.buf
      local opts = { buffer = bufnr }

      vim.keymap.set("n", "<leader>lp", function()
        require("custom.configs.omnisharp").load_project_picker()
      end, vim.tbl_extend("force", opts, { desc = "Load OmniSharp project" }))

      vim.keymap.set("n", "<leader>lb", function()
        require("custom.configs.omnisharp").go_back()
      end, vim.tbl_extend("force", opts, { desc = "Go back to previous project" }))

      vim.keymap.set("n", "<leader>lh", function()
        require("custom.configs.omnisharp").history_picker()
      end, vim.tbl_extend("force", opts, { desc = "Show project history" }))
    end
  end,
})

map("n", "<leader>drr", function()
  local dap = require("dap")
  if dap.session() then
    dap.terminate()
  else
    dap.continue()
  end
end, { desc = "toggle debugger" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "dap continue" })
map("n", "<leader>dl", function()
  require("dap").run_last()
end)
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "dap toggle breakpoint" })
map("n", "<leader>ds", function()
  require("dap").step_over()
end, { desc = "dap step over" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "dap step into" })
map("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "dap step out" })
map("n", "<leader>dt", ":DapViewToggle<CR>", { desc = "dap toggle ui" })

map("n", "<leader>dw", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes, { border = "rounded" })
end, { desc = "get scopes in dap" })

map("n", "<leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.cursor_float(widgets.frames, { border = "rounded" })
end, { desc = "get frames in dap" })

map("n", "<leader>dk", function()
  require("dap.ui.widgets").hover(nil, { border = "rounded" })
end, { desc = "dap hover" })

-- Save breakpoints to file automatically.
-- map("n", "<YourKey1>", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
-- map("n", "<YourKey2>", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
-- map("n", "<YourKey3>", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
-- map("n", "<YourKey4>", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>", opts)

-- Markdown checkbox toggle
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>tt", function()
      local line = vim.api.nvim_get_current_line()
      local new_line

      if line:match("^%s*%-%s*%[%s*%]") then
        new_line = line:gsub("^(%s*%-%s*)%[%s*%]", "%1[x]", 1)
      elseif line:match("^%s*%-%s*%[[xX]%]") then
        new_line = line:gsub("^(%s*%-%s*)%[[xX]%]", "%1[ ]", 1)
      else
        return
      end
      vim.api.nvim_set_current_line(new_line)
    end, { buffer = true, desc = "Toggle markdown checkbox" })
  end,
})
