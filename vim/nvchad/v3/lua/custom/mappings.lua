local map = vim.keymap.set

map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

map("n", "<leader>fm", function()
  if vim.bo.filetype == "cs" then
    vim.cmd("DotnetFormat")
  else
    require("conform").format({ lsp_format = "fallback" })
  end
end, { desc = "Format file" })

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

-- map("n", "<leader>ax", ":%bd | e# | bd# | :NvimTreeToggle<CR>", { desc = "close all buf but current" })
map("n", "<leader>ax", function()
  local current = vim.fn.bufnr("%")
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype ~= "terminal" then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
  vim.cmd("NvimTreeToggle")
end, { desc = "close all buf but current" })

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

-- TODO(@nolleh) refactor
map("n", "gh", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local win_id = vim.api.nvim_get_current_win()

  local first = vim.fn.line("w0", win_id)
  local last = vim.fn.line("w$", win_id)
  local lines = vim.fn.getbufline(bufnr, first, last)

  local refs = {}
  local seen = {}

  local pattern_with_line = "([~%.%w/_%-][~%w%./_%-]*):(%d+)"
  for i, line in ipairs(lines) do
    local search_start = 1
    while true do
      local s, e, path, lnum = line:find(pattern_with_line, search_start)
      if not s then
        break
      end
      -- filter out timestamps like 22:35 (path is just digits)
      if not path:match("^%d+$") and #path >= 2 then
        local entry = path .. ":" .. lnum
        if not seen[entry] then
          seen[entry] = true
          table.insert(refs, {
            path = path,
            line = tonumber(lnum),
            display = entry,
            buf_line = first + i - 1,
            col = s - 1,
          })
        end
      end
      search_start = e + 1
    end
  end

  local pattern_file_only = "([~%.%w/_%-][~%w%./_%-]*)"
  for i, line in ipairs(lines) do
    local search_start = 1
    while true do
      local s, e, path, lnum = line:find(pattern_file_only, search_start)
      if not s then
        break
      end
      -- Skip if followed by :number (already matched above)
      local next_chars = line:sub(e + 1, e + 2)
      local looks_like_path = path:match("/") or path:match("%.")

      if not next_chars:match("^:%d") and not seen[path] and #path >= 2 and looks_like_path then
        seen[path] = true
        table.insert(refs, {
          path = path,
          line = 1,
          display = path,
          buf_line = first + i - 1,
          col = s - 1,
        })
      end
      search_start = e + 1
    end
  end

  if #refs == 0 then
    vim.notify("No file:line patterns found", vim.log.levels.INFO)
    return
  end

  local function get_hint_key(idx)
    if idx <= 26 then
      return string.char(96 + idx)
    else
      local f = math.floor((idx - 1) / 26)
      local s = ((idx - 1) % 26) + 1
      return string.char(96 + f) .. string.char(96 + s)
    end
  end

  vim.api.nvim_set_hl(0, "FileHintBg", { fg = "#1a1b26", bg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "FileHintLeft", { fg = "#7aa2f7", bg = "NONE" })
  vim.api.nvim_set_hl(0, "FileHintRight", { fg = "#7aa2f7", bg = "NONE" })

  local ns = vim.api.nvim_create_namespace("file_hints")
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local hint_map = {}
  for idx, ref in ipairs(refs) do
    local key = get_hint_key(idx)
    hint_map[key] = ref
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, ref.buf_line - 1, ref.col, {
      virt_text = {
        { "", "FileHintLeft" },
        { " " .. key .. " ", "FileHintBg" },
        { "", "FileHintRight" },
      },
      virt_text_pos = "inline",
      priority = 1000,
    })
  end

  vim.cmd("redraw")
  vim.api.nvim_echo({ { "Press hint key (or Esc to cancel: )", "Question" } }, false, {})

  local input = ""
  local max_len = #refs > 26 and 2 or 1

  while true do
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or char == "\27" then -- Esc
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      vim.api.nvim_echo({ { "" } }, false, {})
      return
    end

    input = input .. char

    if hint_map[input] then
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      vim.api.nvim_echo({ { "" } }, false, {})

      local ref = hint_map[input]

      local target_win
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype
        local cfg = vim.api.nvim_win_get_config(win)
        if
          (not cfg.relative or cfg.relative == "")
          and bt ~= "terminal"
          and bt ~= "prompt"
          and ft ~= "neo-tree"
          and ft ~= "NvimTree"
          and ft ~= "oil"
        then
          target_win = win
          break
        end
      end

      local path = ref.path
      if path:match("^~") then
        path = path:gsub("^~", vim.fn.expand("~"))
      elseif not path:match("^/") then
        path = vim.fn.getcwd() .. "/" .. path
      end

      if vim.fn.filereadable(path) == 0 then
        vim.notify("File not found: " .. path, vim.log.levels.INFO)
        return
      end

      if target_win then
        vim.api.nvim_win_call(target_win, function()
          vim.cmd("edit " .. vim.fn.fnameescape(path))
        end)
        vim.api.nvim_set_current_win(target_win)
      else
        vim.cmd("edit " .. vim.fn.fnameescape(path))
      end

      vim.api.nvim_win_set_cursor(0, { ref.line, 0 })
      vim.cmd("normal! zz")

      return
    elseif #input >= max_len then
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      vim.api.nvim_echo({ { "No match for: " .. input, "ErrorMsg" } }, false, {})
      return
    end
  end
end, { desc = "File hints: inline labels" })
