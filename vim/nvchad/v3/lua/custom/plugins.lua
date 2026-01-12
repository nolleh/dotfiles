local plugins = {
  {
    "stevearc/conform.nvim",
    opts = require("custom.configs.conform"),
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- A list of parser names or "all"
      ensure_installed = {
        "bash",
        "css",
        "scss",
        "json",
        "html",
        "svelte",
        "javascript",
        "typescript",
        "python",
        "vim",
        "vimdoc",
        "regex",
        "sql",
        "prisma",
        "go",
        "gomod",
        "gosum",
        "yaml",
        "glimmer",
        "c",
        "cpp",
        "cmake",
        "proto",
        "kotlin",
        "mermaid",
        "markdown",
        "markdown_inline",
        "c_sharp",
        "kdl",
        "xml",
        "tsx",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        highlight_git = true,
      },
      view = {
        width = {
          max = 40,
        },
      },
    },
  },

  -- "jose-elias-alvarez/null-ls.nvim",
  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --   "nolleh/null-ls.nvim",
    --   config = function()
    --     require("custom.configs.null-ls")
    --   end,
    -- },

    config = function()
      -- require("configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate", "MasonUninstall", "MasonUninstallAll" },
    opts = {
      ensure_installed = {
        "codespell",
        "yaml-language-server",
        "omnisharp",
        "glow",

        -- lua stuff
        "bash-language-server",
        "lua-language-server",
        "stylua",

        -- web dev
        "css-lsp",
        "html-lsp",
        "svelte-language-server",
        "typescript-language-server",
        "prisma-language-server",
        "json-lsp",
        "prettier",
        "tailwindcss-language-server",

        -- shell
        "shfmt",
        "shellcheck",
        --
        "pyright",
        "black",
        "gopls",
        "helm-ls",
        "kotlin-language-server",
        "ktlint",

        -- c++
        "cmake-language-server",
        "gersemi",
        "cpplint",
        "clang-format",
        "buf",

        -- c#
        "csharp-language-server",
        "omnisharp",
        "csharpier",
        "deno",
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})
    end,
  },

  {
    "nolleh/jaq-nvim",
    cmd = { "Jaq" },
    config = function()
      require("custom.configs.jaq-nvim")
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("custom.configs.lsp-saga")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
  -- {
  --   "vimwiki/vimwiki",
  --   lazy = false,
  --   config = function()
  --     -- register markdown as parser for vimwiki files
  --     vim.treesitter.language.register("markdown", "vimwiki")
  --   end,
  -- },

  { "NLKNguyen/pipe.vim", cmd = { "PipeUse", "PipeToFile" } },
  { "nolleh/pipe-mysql.vim", ft = { "sql", "mysql" }, dependencies = { "NLKNguyen/pipe.vim" } },
  { "wfxr/minimap.vim", cmd = { "MinimapToggle" } },
  -- ["chrisbra/Colorizer"] = {},
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
  },
  { "mtdl9/vim-log-highlighting", ft = { "log" } },
  -- { "github/copilot.vim", event = { "BufReadPre", "BufNewFile" } },
  -- {
  --   "3rd/diagram.nvim",
  --   ft = { "markdown" },
  --   dependencies = {
  --     "3rd/image.nvim",
  --   },
  --   config = function()
  --     require("custom.configs.diagram")
  --   end,
  -- },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante", "vimwiki" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  -- {
  --   "madox2/vim-ai",
  --   event = { "BufReadPre", "BufNewFile" },
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- set this if you want to always pull the latest change
  --   config = function()
  --     require("custom.configs.avante")
  --   end,
  --   opts = {
  --     -- add any opts here
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     "ravitemer/mcphub.nvim",
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante", "vimwiki" },
  --       },
  --       ft = { "markdown", "Avante", "vimwiki" },
  --     },
  --   },
  -- },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
      require("custom.configs.ibl")
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- {
  --   "3rd/image.nvim",
  --   build = false,
  --   opts = {},
  --   config = function()
  --     require("custom.configs.image")
  --   end,
  -- },

  -- {
  --   "3rd/diagram.nvim",
  --   lazy = false,
  --   dependencies = {
  --     "3rd/image.nvim",
  --   },
  --   opts = { -- you can just pass {}, defaults below
  --     renderer_options = {
  --       mermaid = {
  --         background = nil, -- nil | "transparent" | "white" | "#hex"
  --         theme = nil, -- nil | "default" | "dark" | "forest" | "neutral"
  --         scale = 1, -- nil | 1 (default) | 2  | 3 | ...
  --         width = nil, -- nil | 800 | 400 | ...
  --         height = nil, -- nil | 600 | 300 | ...
  --       },
  --       plantuml = {
  --         charset = nil,
  --       },
  --       d2 = {
  --         theme_id = nil,
  --         dark_theme_id = nil,
  --         scale = nil,
  --         layout = nil,
  --         sketch = nil,
  --       },
  --     },
  --   },
  --   config = function()
  --     require("custom.configs.diagram")
  --   end,
  -- },
  --
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    ft = {
      "cs",
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "igorlfs/nvim-dap-view" },
      opts = {
        winbar = {
          show = true,
          -- You can add a "console" section to merge the terminal with the other views
          sections = { "watches", "exceptions", "breakpoints", "threads", "repl" },
          -- Must be one of the sections declared above
          default_section = "watches",
        },
        windows = {
          height = 15,
          terminal = {
            -- 'left'|'right'|'above'|'below': Terminal position in layout
            position = "left",
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = false,
          },
        },
      },
      "Weissle/persistent-breakpoints.nvim",
      "leoluz/nvim-dap-go",
      "Cliffback/netcoredbg-macOS-arm64.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    cmd = {
      "DapNew",
      "DapViewToggle",
    },
    config = function()
      require("custom.configs.dap").setup()
    end,
  },

  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },

  {
    "skanehira/denops-docker.vim",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },

  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = {
        -- your image configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        enabled = true,
      },
    },
    config = function(_, opts)
      require("custom.configs.snacks").setup(opts)
    end,
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ravitemer/mcphub.nvim",
  --   },
  --   cmd = { "CodeCompanion", "CodeCompanionChat" },
  --   config = function()
  --     require("codecompanion").setup({
  --       strategies = {
  --         chat = {
  --           tools = {
  --             ["mcp"] = {
  --               -- calling it in a function would prevent mcphub from being loaded before it's needed
  --               callback = function()
  --                 return require("mcphub.extensions.codecompanion")
  --               end,
  --               description = "Call tools and resources from the MCP Servers",
  --               opts = {
  --                 requires_approval = true,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3000, -- Port for MCP Hub server
        -- config = vim.fn.expand("~/Library/Application Support/Claude/claude_desktop_config.json"), -- Absolute path to config file
        config = vim.fn.expand(vim.env.HOME .. "/mcp.json"),

        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
  {
    "nolleh/sqlflick.nvim",
    config = function()
      require("sqlflick").setup(require("custom.configs.sqlflick"))
    end,
    cmd = { "SQLFlickSelectDB", "SQLFlickExecute", "SQLFlickExecuteBuf" },
    ft = { "sql" },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      require("telescope").load_extension("lazygit")
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = require("custom.configs.claudecode").opts,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    config = require("custom.configs.claudecode").config(),
  },
}

return plugins
