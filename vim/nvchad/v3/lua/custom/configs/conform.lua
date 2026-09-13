-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    bash = { "shfmt" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    svelte = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },

    cpp = { "clang-format" },
    go = { "gofmt" },
    -- Use Roslyn's LSP formatter, which follows .editorconfig.
    cs = { lsp_format = "first" },
    toml = { "prettier" },
    python = { "black" },
    make = { "bake" },
  },

  -- format_on_save = {
  --   timeout_ms = 5000,
  --   lsp_format = "fallback",
  -- },
}

return options
