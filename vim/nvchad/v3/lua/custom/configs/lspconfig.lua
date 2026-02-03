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
  "jsonls",
  "tailwindcss",
  "omnisharp",
  "kotlin_lsp"
}

local util = require("lspconfig/util")
local path = util.path

local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
  end, { buffer = bufnr, desc = "Lsp definition (Telescope)" })
  vim.keymap.set("n", "gD", function()
    require("telescope.builtin").lsp_type_definitions()
  end, { buffer = bufnr, desc = "Lsp type definition (Telescope)" })
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

    -- Cache of loaded solutions: { [sln_dir] = { project_dirs = { "/abs/path/to/project", ... } } }
    _G.omnisharp_solution_cache = _G.omnisharp_solution_cache or {}

    -- Parse .sln file and extract project directories
    local function parse_solution_dirs(sln_path)
      local project_dirs = {}
      local file = io.open(sln_path, "r")
      if not file then
        return project_dirs
      end

      local sln_dir = vim.fn.fnamemodify(sln_path, ":h")
      for line in file:lines() do
        local _, rel_path = line:match('Project%("[^"]*"%)%s*=%s*"([^"]+)"%s*,%s*"([^"]+%.csproj)"')
        if rel_path then
          local abs_path = vim.fn.simplify(sln_dir .. "/" .. rel_path:gsub("\\", "/"))
          local project_dir = vim.fn.fnamemodify(abs_path, ":h")
          table.insert(project_dirs, project_dir)
        end
      end
      file:close()
      return project_dirs
    end

    -- Check if file belongs to any cached solution
    local function find_cached_solution(fname)
      for sln_dir, cache in pairs(_G.omnisharp_solution_cache) do
        for _, project_dir in ipairs(cache.project_dirs) do
          if fname:find(project_dir, 1, true) == 1 then
            return sln_dir
          end
        end
      end
      return nil
    end

    -- Find nearest .sln file
    local function find_nearest_sln(fname)
      local dir = vim.fn.fnamemodify(fname, ":h")
      while dir ~= "/" do
        local slns = vim.fn.glob(dir .. "/*.sln", false, true)
        if #slns > 0 then
          return slns[1], dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end
      return nil, nil
    end

    -- Dynamic root_dir: reuse existing solution if file belongs to it
    -- nvim 0.11+ requires root_dir(bufnr, on_dir) signature with on_dir() callback
    config.root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)

      -- 1. Check if file belongs to already loaded solution
      local cached_sln_dir = find_cached_solution(fname)
      if cached_sln_dir then
        on_dir(cached_sln_dir)
        return
      end

      -- 2. Find nearest .sln and cache it
      local sln_path, sln_dir = find_nearest_sln(fname)
      if sln_path and sln_dir then
        local project_dirs = parse_solution_dirs(sln_path)
        _G.omnisharp_solution_cache[sln_dir] = { project_dirs = project_dirs }
        on_dir(sln_dir)
        return
      end

      -- 3. Fallback to .csproj
      local fallback = util.root_pattern("*.csproj")(fname)
      if fallback then
        on_dir(fallback)
      end
    end

    -- Disable Neovim's file watching to prevent UI freezing on external file changes.
    -- OmniSharp has its own file watcher that handles this asynchronously on the server side.
    config.capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
        },
      },
    })

    config.on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      vim.keymap.set("n", "gd", function()
        require("omnisharp_extended").telescope_lsp_definition()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to definition (Omnisharp)",
      })
      vim.keymap.set("n", "gD", function()
        require("omnisharp_extended").telescope_lsp_type_definition()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to type definition (Omnisharp)",
      })
      vim.keymap.set("n", "gr", function()
        require("omnisharp_extended").telescope_lsp_references()
      end, {
        buffer = bufnr,
        noremap = true,
        desc = "Go to references (OmniSharp)",
      })
      vim.keymap.set("n", "gi", function()
        require("omnisharp_extended").telescope_lsp_implementation()
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
