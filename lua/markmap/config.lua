-- Config options to keep init clean.
local M = {}

local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
local is_android = vim.fn.isdirectory('/data') == 1

---Parse user options, or set the defaults
---@param opts table A table with options to set.
M.set = function(opts)
  -- Setup options
  M.html_output = opts.html_output or nil
  M.hide_toolbar = opts.hide_toolbar or false
  M.grace_period = opts.grace_period or 3600000 -- 60min
  M.markmap_cmd = opts.markmap_cmd or nil

  -- Set defaults: M.html_output
  if M.html_output == nil then
    if is_windows then
      M.html_output = vim.uv.os_getenv("TEMP") .. "\\" .. "markmap.html"
    elseif is_android then
      M.html_output = "/data/data/com.termux/files/usr/tmp/markmap.html"
    else -- unix
      M.html_output = "/tmp/markmap.html"
    end
  end

  -- Set defaults: M.hide_toolbar
  if M.hide_toolbar == true then
    M.hide_toolbar = "--no-toolbar"
  else
    M.hide_toolbar = nil
  end

  -- Set defaults: M.markmap_cmd
  if M.markmap_cmd == nil then
    if is_windows then
      M.markmap_cmd = "markmap.cmd" -- windows requires this special command.
    else
      M.markmap_cmd = "markmap"
    end
  end

  -- Expose config globally
  vim.g.markmap_config = M
end

return M
