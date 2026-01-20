local M = {}

function M.runsys(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

-- Find solution or project file from given directory or parents
-- Returns: path, type ("solution" or "project")
function M.find_solution_or_project(start_dir)
  local cwd = start_dir or vim.fn.getcwd()

  local sln_files = vim.fn.glob(cwd .. "/*.sln", false, true)
  if #sln_files > 0 then
    return sln_files[1], "solution"
  end

  local csproj_files = vim.fn.glob(cwd .. "/*.csproj", false, true)
  if #csproj_files > 0 then
    return csproj_files[1], "project"
  end

  -- Search in parent directories
  local parent = vim.fn.fnamemodify(cwd, ":h")
  while parent ~= cwd do
    sln_files = vim.fn.glob(parent .. "/*.sln", false, true)
    if #sln_files > 0 then
      return sln_files[1], "solution"
    end

    csproj_files = vim.fn.glob(parent .. "/*.csproj", false, true)
    if #csproj_files > 0 then
      return csproj_files[1], "project"
    end

    cwd = parent
    parent = vim.fn.fnamemodify(cwd, ":h")
  end

  return nil, nil
end

return M
