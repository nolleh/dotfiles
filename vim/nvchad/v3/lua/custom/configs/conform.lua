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
    cs = { "csharpier" },
    toml = { "prettier" },
    python = { "black" },
  },
}

return options
