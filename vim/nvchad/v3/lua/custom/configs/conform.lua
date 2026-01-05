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
    -- cs = { "csharpier" },
    cs = { "dotnet_format" },
    toml = { "prettier" },
    python = { "black" },
  },

  formatters = {
    dotnet_format = {
      command = "dotnet",
      args = { "format", "whitespace", "--include", "$FILENAME", "--no-restore" },
      stdin = false,
      timeout_ms = 30000,
    },
  },
}

return options
