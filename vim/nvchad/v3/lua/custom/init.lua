-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/
-- add command, options, autocmds here

-- Variables: {{{

local function system(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

-- local brew = os.getenv('BREW')
-- vim.g.python3_host_prog = brew .. "/python3"
vim.g.python3_host_prog = system("which python3")

local enable_providers = {
  "python3_provider",
  "node_provider",
  -- and so on
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end

vim.g.vimwiki_ext2syntax = vim.empty_dict()

-- }}}

-- Plugin configurations: {{{
-- disable netrw at the very start of your init.lua (strongly advised)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.tagbar_position = "rightbelow"
--vim.g.mapleader = ","
vim.g.pipemysql_login_info = {
  {
    description = "127.0.0.1",
    mysql_username = "root",
  },
}

vim.g.pipemysql_option = "-vvv"
-- vim.g.pipemysql_pager = "grcat ~/.grcat"

vim.g.vimwiki_list = {
  {
    path = vim.env.WS_GITHUB .. "/vwiki/private",
  },
  {
    path = vim.env.WS_GITHUB .. "/vwiki/public",
  },
}

-- vim.g.colorizer_auto_color = 1
-- vim.g.colorizer_auto_filetype="*"
-- vim.g.colorizer_disable_bufleave = 1
-- vim.env.NVIM_MKDP_LOG_FILE = "/Users/nolleh/tmp/mkdp-log.log"
-- vim.env.NVIM_MKDP_LOG_LEVEL = "debug"

vim.g.copilot_no_tap_map = true

vim.cmd([[
  hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
  let g:minimap_cursor_color = 'MinimapCurrentLine'
]])

-- Augroups: {{{
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local projectDrawer = augroup("ProjectDrawer", {})

autocmd("VimEnter", {
  pattern = "*",
  command = ":NvimTreeToggle",
  group = projectDrawer,
})

autocmd("VimEnter", {
  pattern = "*",
  command = ":wincmd l",
  group = projectDrawer,
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.sql",
  command = "set filetype=mysql",
})

local zoomed = false
function ZoomToggle()
  if zoomed then
    vim.cmd(":tab close")
    zoomed = false
  else
    vim.cmd(":tab split")
    zoomed = true
  end
end

vim.api.nvim_create_user_command("ZoomToggle", ZoomToggle, {})

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
--

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
    end

    -- if (client) then
    --   print(vim.inspect(client.server_capabilities))
    -- end

    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      if client and client.server_capabilities.codeActionProvider then
        -- local bufnr = vim.api.nvim_get_current_buf()
        -- if client and client.supports_method("textDocument/CodeAction", bufnr) then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
      end

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})

vim.cmd([[
function! JumpToNextBufferInJumplist(dir) " 1=forward, -1=backward
    let jl = getjumplist() | let jumplist = jl[0] | let curjump = jl[1]
    let jumpcmdstr = a:dir > 0 ? '<C-O>' : '<C-I>'
    let jumpcmdchr = a:dir > 0 ? '^O' : '^I'    " <C-I> or <C-O>
    let searchrange = a:dir > 0 ? range(curjump+1,len(jumplist))
                              \ : range(curjump-1,0,-1)
    for i in searchrange
        if jumplist[i]["bufnr"] != bufnr('%')
            let n = (i - curjump) * a:dir
            echo "Executing ".jumpcmdstr." ".n." times."
            execute "silent normal! ".n.jumpcmdchr
            break
        endif
    endfor
endfunction
nnoremap <leader><C-O> :call JumpToNextBufferInJumplist(-1)<CR>
nnoremap <leader><C-I> :call JumpToNextBufferInJumplist( 1)<CR>
]])

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "solarized",
  -- group = ...,
  callback = function()
    vim.api.nvim_set_hl(0, "CopilotSuggestion", {
      fg = "#555555",
      ctermfg = 8,
      force = true,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
  pattern = { "dap-float" },
  callback = function(evt)
    vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
  end,
})
