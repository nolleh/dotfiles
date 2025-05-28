local function runsys(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

return { runsys = runsys }
