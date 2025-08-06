-- General utils to keep init clean.
local M = {}

local is_windows = vim.uv.os_uname().sysname == "Windows_NT"

---Wrapper for jobstart.
---On windows, run it with {} so it doesn't spawn a shell.
---On unix, run it as string so it spawn a shell,
---so ENV is available, which is mandatory on termux.
---
---NOTE: In order to work on windows,
---      the executables must be added to path at windows level.
---@param cmd string command to run.
---@param arguments table arguments to pass to the cmd.
---@return number job pid of the job, so we can stop it later.
M.jobstart = function(cmd, arguments)
  if is_windows then
    return vim.fn.jobstart({ cmd, unpack(arguments) })
  else
    return vim.fn.jobstart(cmd .. " " .. table.concat(arguments, " "))
  end
end

---We re-set the arguments we pass to markmap every time we run it to ensure
---they are always clean and correct, as every command get different ones.
---@return table arguments
M.reset_arguments = function()
  local config = vim.g.markmap_config

  local arguments = {}
  if config.html_output ~= "" then   -- if html_output is "", don't pass the parameter
    table.insert(arguments, "-o")
    table.insert(arguments, '"' .. config.html_output .. '"')
  end
  if config.hide_toolbar then table.insert(arguments, config.hide_toolbar) end
  return arguments
end

return M
