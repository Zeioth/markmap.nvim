-- Config options to keep init clean.
local M = {}

local uv = vim.uv or vim.loop
local is_windows = uv.os_uname().sysname == "Windows_NT"
local is_android = vim.fn.isdirectory("/system") == 1

M.set = function(opts)
  -- Setup options
  M.html_output = opts.html_output or nil
  M.hide_toolbar = opts.hide_toolbar or false
  M.grace_period = opts.grace_period or  3600000 -- 60min

  -- Set defaults: M.html_output
  if M.html_output == nil then
    if is_windows then
      M.html_output = uv.os_getenv("TEMP" .. "\\" .. "markmap.html")
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
  if is_windows then
    M.markmap_cmd = "markmap.cmd" -- windows requires this special command.
  else
    M.markmap_cmd = "markmap"
  end

  -- Expose config globally
  vim.g.markmap_config = M
end

return M
