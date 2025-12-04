require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")

-- server_configurations
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  "lua_ls",
  "html",
  "cssls",
  "ts_ls",
  "pyright",
  "svelte",
  "bashls",
  "prismals",
  "gopls",
  "cmake",
  "ccls",
  "kotlin_language_server",
  "jsonls",
  "tailwindcss",
  "omnisharp",
}

local util = require("lspconfig/util")
local path = util.path

local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definition()
  end, { buffer = bufnr, desc = "Lsp definition (Telescope)" })
  vim.keymap.set("n", "gr", function()
    require("telescope.builtin").lsp_references()
  end, { buffer = bufnr, desc = "Lsp references (Telescope)" })

  vim.keymap.set("n", "gi", function()
    require("telescope.builtin").lsp_implementations()
  end, { buffer = bufnr, desc = "Lsp implemenations (Telescope)" })
end

for _, lsp in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }

  if lsp == "lua_ls" then
    config.settings = {
      Lua = {
        -- indicate this Lua code runs in Neovim's LuaJIT environment
        runtime = { version = "LuaJIT"},
        -- here are the external libraries/APIs available at runtime
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
            -- lua_ls pre-bundled type definitions, exposes libuv through vim.loop(old) and vim.uv (newer)
            -- without this, lua_ls wouldn't understand these async I/O APIs.
            "${3rd}/luv/library"
          }
        }
      }
    }
  elseif lsp == "pyright" then
    local function get_python_path(workspace)
      -- Use activated virtualenv.
      if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
      end

      if workspace ~= nil then
        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({ "*", ".*" }) do
          local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
          if match ~= "" then
            return path.join(path.dirname(match), "bin", "python")
          end
        end
      end

      -- Fallback to system Python.
      return "python3"
    end
    config.settings = {
      python = {
        pythonPath = get_python_path(vim.fn.getcwd()),
      },
    }
  elseif lsp == "ccls" then
    local ccls_config = require("custom.configs.ccls").config
    -- config = vim.tbl_deep_extend("force", config, ccls_config.server or {})
    -- if ccls_config.disable_capabilities then
    --   config.disable_capabilities = ccls_config.disable_capabilities
    -- end
    -- if ccls_config.disable_signature then
    --   config.disable_signature = ccls_config.disable_signature
    -- end
    config.settings = ccls_config
  elseif lsp == "omnisharp" then
    local mason = require("custom.utils").runsys("echo $MASON")
    config.cmd = { "dotnet", mason .. "/packages/omnisharp/libexec/OmniSharp.dll", "--languageserver" }
    config.settings = require("custom.configs.omnisharp").config
    config.on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      vim.keymap.set("n", "gd", function()
        require("omnisharp_extended").telescope_lsp_definition()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to definition (Omnisharp)",
      })
      vim.keymap.set("n", "gr", function()
        require("omnisharp_extended").telescope_lsp_definition()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to referencies (OmniSharp)",
      })
      vim.keymap.set("n", "gi", function()
        require("omnisharp_extended").telescope_lsp_definition()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to implementation (OmniSharp)",
      })
    end
  end

  vim.lsp.config(lsp, config)
  vim.lsp.enable(lsp)
end
