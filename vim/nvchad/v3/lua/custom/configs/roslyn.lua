local M = {}

function M.select_target()
  local bufnr = vim.api.nvim_get_current_buf()
  local targets = require("roslyn.sln.discovery").find_solutions_for_buffer(bufnr) or {}

  if #targets == 0 then
    vim.notify("No Roslyn solution targets found", vim.log.levels.WARN)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Select Roslyn target",
      finder = finders.new_table({
        results = targets,
        entry_maker = function(target)
          return {
            value = target,
            display = vim.fn.fnamemodify(target, ":."),
            ordinal = target,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if not selection then
            return
          end

          local file = selection.value
          local config = vim.tbl_deep_extend("force", vim.lsp.config["roslyn"], {
            root_dir = vim.fs.dirname(file),
            on_init = function(client)
              require("roslyn.lsp.on_init").sln(client, file)
            end,
          })

          local client = vim.lsp.get_clients({ name = "roslyn", bufnr = bufnr })[1]
          if not client then
            vim.lsp.start(config, { bufnr = bufnr })
            return
          end

          local emitter = require("roslyn.roslyn_emitter")
          local remove_listener
          remove_listener = emitter.on("stopped", function()
            if remove_listener then
              remove_listener()
            end
            vim.lsp.start(config, { bufnr = bufnr })
          end)

          client:stop(vim.uv.os_uname().sysname == "Windows_NT")
        end)
        return true
      end,
    })
    :find()
end

return M
