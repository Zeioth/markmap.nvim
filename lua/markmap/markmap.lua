-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local M = {}

M.setup = function(ctx)
  -- Setup options
  html_output = ctx.html_output
  hide_toolbar = ctx.hide_toolbar
  grace_period = ctx.hide_toolbar

  -- Set default options
  if html_output == nil then
    local is_windows = vim.loop.os_uname().sysname == "Windows"
    if is_windows then -- windows
      html_output = "C:\\Users\\<username>\\AppData\\Local\\Temp\\markmap.html"
    else -- unix
      html_output = "/tmp/markmap.html"
    end
  end

  if hide_toolbar == true then
    hide_toolbar = "--no-toolbar"
  else
    hide_toolbar = nil
  end

  if grace_period == nil then
    grace_period = 3600000 -- 60min
  end

  -- Set a common job for all commands.
  -- This prevents more than one job running at the same time.
  job = nil

  -- Set common arguments to avoid code repetition.
  arguments = {}
  if html_output ~= "" then -- if html_output is "", don't pass the parameter
    table.insert(arguments, "-o")
    table.insert(arguments, html_output)
  end
  if hide_toolbar then table.insert(arguments, hide_toolbar) end

  -- Setup commands -----------------------------------------------------------
  cmd("MarkmapOpen", function()
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
    if job ~= nil then uv.process_kill(job, 9) end
    job = uv.spawn("markmap", { args = arguments, detached = true }, nil)
  end, { desc = "Show a mental map of the current file" })

  cmd("MarkmapSave", function()
    table.insert(arguments, "--no-open") -- specific to this command
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
    if job ~= nil then uv.process_kill(job, 9) end -- kill -9 jobs
    job = uv.spawn("markmap", { args = arguments, detached = true }, nil)
  end, { desc = "Save the HTML file without opening the mindmap" })
end

cmd("MarkmapWatch", function()
  table.insert(arguments, "--watch") -- spetific to this command
  table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
  if job ~= nil then uv.process_kill(job, 9) end
  job = uv.spawn("markmap", { args = arguments, detached = true }, nil)
end, { desc = "Show a mental map of the current file and watch for changes" })

cmd("MarkmapWatchStop", function()
  if job ~= nil then uv.process_kill(job, 9) end -- kill -9 jobs
end, { desc = "Manually stops markmap watch" })

-- Autocmds --------------------------------------------------------------
-- Kill jobs after a grace period
last_execution = vim.loop.now() -- timer for grace period
autocmd("CursorHold", {
  desc = "Kill all markmap jobs after a grace period",
  group = augroup("markmap_kill_after_grace_period", { clear = true }),
  callback = function()
    -- If grace_periodd is disabled, remove the autocmd and return
    if grace_period == 0 then
      vim.cmd "autocmd! markmap_kill_after_grace_period"
      return
    end

    -- Otherwise, use grace_period
    current_time = vim.loop.now()
    if current_time - last_execution >= grace_period then -- if grace period exceeded
      if job ~= nil then uv.process_kill(job, 9) end -- kkill -9 jobs
      last_execution = current_time -- update time
    end
  end,
})

-- Before nvim exits, stop all jobs
autocmd("VimLeavePre", {
  desc = "Kill all markmap jobs before closing nvim",
  group = augroup("markmap_kill_pre_exit_nvim", { clear = true }),
  callback = function()
    if job ~= nil then uv.process_kill(job, 9) end -- kill -9 jobs
  end,
})

return M
