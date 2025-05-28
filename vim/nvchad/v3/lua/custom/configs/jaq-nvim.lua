local util = require("lspconfig/util")
local path = util.path
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ "*", ".*" }) do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      return path.join(path.dirname(match), "bin", "python")
    end
  end

  -- Fallback to system Python.
  -- return exepath("python3") or exepath("python") or "python"
  return "python3"
end

require("jaq-nvim").setup({
  cmds = {
    -- Uses vim commands
    internal = {
      lua = "luafile %",
      vim = "source %",
    },

    -- Uses shell commands
    external = {
      vimwiki = "glow %",
      markdown = "glow %",
      python = get_python_path(".") .. " %",
      go = "go run %",
      sh = "sh %",
      html = "open %",
      prisma = "pnpm exec prisma generate",
    },
  },
  -- UI settings
  ui = {
    -- Auto-save the current file
    -- before executing it
    autosave = true,
    -- Start in insert mode
    startinsert = false,

    -- Switch back to current file
    -- after using Jaq
    wincmd = false,

    -- Floating Window / FTerm settings
    float = {
      -- Floating window border (see ':h nvim_open_win')
      border = "rounded",

      -- Num from `0 - 1` for measurements
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,

      -- Highlight group for floating window/border (see ':h winhl')
      border_hl = "FloatBorder",
      float_hl = "Normal",

      -- Floating Window Transparency (see ':h winblend')
      blend = 0,
    },
  },
})
