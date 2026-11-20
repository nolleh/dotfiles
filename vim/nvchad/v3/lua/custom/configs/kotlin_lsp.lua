local M = {}

local function clamp(value, min, max)
  value = tonumber(value) or min
  if value < min then
    return min
  end
  if value > max then
    return max
  end
  return value
end

local function kotlin_client(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "kotlin_lsp" })) do
    return client
  end
end

local function as_locations(result)
  if not result or vim.tbl_isempty(result) then
    return {}
  end
  if vim.islist(result) then
    return result
  end
  return { result }
end

local function clamp_location(location)
  local uri = location.uri or location.targetUri
  if not uri then
    return nil
  end

  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end

  if not vim.api.nvim_buf_is_loaded(bufnr) then
    pcall(vim.fn.bufload, bufnr)
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local fixed = vim.deepcopy(location)
  local range = fixed.range or fixed.targetSelectionRange
  if not range or not range.start then
    return fixed
  end

  range.start.line = clamp(range.start.line, 0, math.max(line_count - 1, 0))
  range.start.character = 0
  range["end"] = vim.deepcopy(range.start)

  return fixed
end

local function safe_show_document(location, offset_encoding)
  local ok, result = pcall(vim.lsp.util.show_document, location, offset_encoding, { focus = true })
  if ok then
    return result
  end

  local message = tostring(result)
  if not message:find("Cursor position outside buffer", 1, true) then
    vim.notify("Kotlin LSP definition jump failed: " .. message, vim.log.levels.WARN)
    return false
  end

  local fixed = clamp_location(location)
  if not fixed then
    vim.notify("Kotlin LSP returned an invalid definition location", vim.log.levels.WARN)
    return false
  end

  local retry_ok, retry_result = pcall(vim.lsp.util.show_document, fixed, offset_encoding, { focus = true })
  if retry_ok then
    vim.notify("Adjusted invalid Kotlin LSP definition target", vim.log.levels.WARN)
    return retry_result
  end

  vim.notify("Kotlin LSP definition jump failed: " .. tostring(retry_result), vim.log.levels.WARN)
  return false
end

function M.definition()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = kotlin_client(bufnr)
  local offset_encoding = (client and client.offset_encoding) or "utf-16"
  local params = vim.lsp.util.make_position_params(0, offset_encoding)

  vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result, ctx)
    if err then
      vim.notify("Kotlin LSP definition failed: " .. err.message, vim.log.levels.ERROR)
      return
    end

    local locations = as_locations(result)
    if #locations == 0 then
      vim.notify("No Kotlin definition found", vim.log.levels.INFO)
      return
    end

    if #locations > 1 then
      require("telescope.builtin").lsp_definitions({ jump_type = "never" })
      return
    end

    local response_client = vim.lsp.get_client_by_id(ctx.client_id)
    safe_show_document(locations[1], (response_client and response_client.offset_encoding) or offset_encoding)
  end)
end

return M
