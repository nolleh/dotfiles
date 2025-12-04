local M = {}

M.project_history = {}

local function parse_solution(sln_path)
  local projects = {}
  local file = io.open(sln_path, "r")
  if not file then
    return projects
  end

  local sln_dir = vim.fn.fnamemodify(sln_path, ":h")

  for line in file:lines() do
    -- "Project("{FAE04EC0=301F-11D3...}) = "MyProject", "src\MyProject\MyProject.csproj", "{GUID}"
    -- name: "MyProject", rel_path: "src\MyProject\MyProject.csproj"
    local name, rel_path = line:match('Project%("{[^}]+}"%)[^"]*"([^"]*"([^"]+)"[^"]*"([^"([^"]+%.csproj)"]))')
    if name and rel_path then
      local abs_path = vim.fn.simplify(sln_dir .. "/" .. rel_path:gsub("\\", "/"))
      table.insert(projects, {
        name = name,
        path = abs_path,
        rel_path = rel_path,
      })
    end
  end
  file:close()
  return projects
end

-- File solution file from current directory or parents
local function find_solution()
  local cwd = vim.fn.getcwd()
  local sln_files = vim.fn.glob(cwd .. "/*.sln", false, true)
  if #sln_files > 0 then
    return sln_files
  end
  local parent = vim.fn.fnamemodify(cwd, ":h")
  while parent ~= cwd do
    sln_files = vim.fn.glob(parent .. "/*.sln", false, true)
    if #sln_files > 0 then
      return sln_files[1]
    end
    cwd = parent
    parent = vim.fn.fnamemodify(cwd, ":h")
  end
  return nil
end

-- Load a specific project by changing cwd and opening a .cs file
function M.load_project(project, sln_path)
  local project_dir = vim.fn.fnamemodify(project.path, ":h")
  local cs_files = vim.fn.glob(project_dir .. "/**/*.cs", false, true)
  if #cs_files > 0 then
    local current_cwd = vim.fn.getcwd()
    local current_sln = find_solution()
    if current_cwd ~= project_dir then
      if #M.project_history == 0 or M.project_history[#M.project_history].dir ~= current_cwd then
        table.insert(M.project_history, {
          name = vim.fn.fnamemodify(current_cwd, ":t"),
          dir = current_cwd,
          sln_path = current_sln,
        })
      end
    end
    vim.cmd("cd " .. vim.fn.fnameescape(project_dir))
    vim.cmd("edit " .. vim.fn.fnameescape(cs_files[1]))
    vim.notify("loaded project: " .. project.name .. " [cwd: ]" .. project_dir .. ")", vim.log.levels.INFO)
  else
    vim.notify("No .cs files found in: " .. project.name, vim.log.levels.WARN)
  end
end

-- Go back to previous project in history
function M.go_back()
  if #M.project_history == 0 then
    vim.notify("No project history", vim.log.levels.WARN)
    return
  end
  local current_cwd = vim.fn.getcwd()
  local current_sln = find_solution()

  local prev = table.remove(M.project_history)

  table.insert(M.project_history, 1, {
    name = vim.fn.fnamemodify(current_cwd, ":t"),
    dir = current_cwd,
    sln_path = current_sln,
  })

  vim.cmd("cd " .. vim.fn.fnameescape(prev.dir))
  local cs_files = vim.fn.glob(prev.dir .. "/**/*.cs", false, true)
  if #cs_files > 0 then
    vim.cmd("edit " .. vim.fn.fnamespace(cs_files[1]))
  end
  vim.notify("Back to: " .. prev.name .. " (cwd: )" .. prev.dir .. ")", vim.log.levels.INFO)
end

-- Show project history picker
function M.history_picker()
  if #M.project_history == 0 then
    vim.notify("No project history", vim.log.levels.WARN)
  end

  local ok, telescope = pcall(require, "telescope.picers")
  if ok then
    local finders = require("telescope.finders")
    local conf = require("telesope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    telescope
      .new({}, {
        prompt_title = "Project History",
        finder = finders.new_table({
          results = M.project_history,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name .. " ( " .. entry.dir .. ")",
              ordinal = entry.name .. " " .. entry.dir,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              local entry = selection.value
              -- Save befor jumping
              local current_cwd = vim.fn.getcwd()
              local current_sln = find_solution()
              if current_cwd ~= entry.dir then
                table.insert(M.project_history, {
                  name = vim.fn.fnamemodify(current_cwd, ":t"),
                  dir = current_cwd,
                  sln_path = current_sln,
                })
              end
              -- Remove selected entry
              for i, h in ipairs(M.project_history) do
                if h.dir == entry.dir then
                  table.remove(M.project_history, i)
                  break
                end
              end
              -- Go
              vim.cmd("cd " .. vim.fn.fnameescape(entry.dir))
              local cs_files = vim.fn.glob(entry.dir .. "/**/*/cs", false, true)
              if #cs_files > 0 then
                vim.cmd("edit " .. vim.fn.fnameescape(cs_files[1]))
              end
              vim.notify("Switched to: " .. entry.name, vim.log.levels.INFO)
            end
          end)
          return true
        end,
      })
      :find()
  else
    -- Fallback to vim.ui.select
    local items = {}
    for _, p in ipairs(M.project_history) do
      table.insert(items, p.name .. " (" .. p.dir .. ")")
    end
    vim.ui.select(items, { prompt = "Select project from history: " }, function(_, idx)
      if idx then
        local entry = M.project_history[idx]
        vim.cmd("cd " .. vim.fn.fnameescape(entry.dir))
        local cs_files = vim.fn.glob(entry.dir .. "/**/*.cs", false, true)
        if #cs_files > 0 then
          vim.cmd("edit " .. vim.fn.fnameescape(cs_files[1]))
        end
        vim.notify("Switched to: " .. entry.name, vim.log.levels.INFO)
      end
    end)
  end
end

--Show popup picker to sleect and load a project
function M.load_prject_picker()
  local sln_path = find_solution()
  if not sln_path then
    vim.notify("No solution file fiound", vim.log.levels.ERROR)
    return
  end

  local projects = parse_solution(sln_path)
  if #projects == 0 then
    vim.notify("NO projects found in solution", vim.log.levels.WARN)
    return
  end

  local ok, telescope = pcall(require, "telescope.pickers")
  if ok then
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    telescope
      .new({}, {
        prompt_title = "Load OmniSharp Project",
        finder = finders.new_table({
          results = projects,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name .. " (" .. entry.rel_path .. ")",
              ordinal = entry.name,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.cloase(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              M.load_project(selection.value)
            end
          end)
          return true
        end,
      })
      :find()
  else
    -- Fallback to vim.ui.select
    local items = {}
    for _, p in ipairs(projects) do
      table.insert(items, p.name)
    end
    vim.ui.select(items, { prompt = "Select project to load:" }, function(_, idx)
      if idx then
        M.load_project(projects[idx])
      end
    end)
  end
end

M.config = {
  FormattingOptions = {
    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    EnableEditorConfigSupport = true,
    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    OrganizeImports = nil,
  },
  MsBuild = {
    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    LoadProjectsOnDemand = true,
  },
  RoslynExtensionsOptions = {
    -- Enables support for roslyn analyzers, code fixes and rulesets.
    EnableAnalyzersSupport = false,
    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    EnableImportCompletion = false,
    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    AnalyzeOpenDocumentsOnly = true,

    -- EnableDecompilationSupport = true,
  },
  Sdk = {
    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    IncludePrereleases = true,
  },
}

return M
