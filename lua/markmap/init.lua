-- This plugin is a wrapper for markmap-cli
local uv = vim.uv or vim.loop
local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local M = {}

M.setup = function(ctx)
  -- Detect OS
  local is_windows = uv.os_uname().sysname == "Windows_NT"
  local is_android = vim.fn.isdirectory "/system" == 1

  -- Setup options
  local html_output = ctx.html_output
  local hide_toolbar = ctx.hide_toolbar
  local grace_period = ctx.grace_period

  -- Set default options
  if html_output == nil then
    if is_windows then -- windows
      html_output = uv.os_getenv "TEMP" .. "\\" .. "markmap.html"
    elseif is_android then -- android
      html_output = "/data/data/com.termux/files/usr/tmp/markmap.html"
    else                   -- unix
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

  -- Windows requires a different command.
  local run_markmap = "markmap"
  if is_windows then
    run_markmap = "markmap.cmd"
  end

  -- Set a common job for all commands.
  -- This prevents more than one job running at the same time.
  local job = nil

  -- Set common arguments to avoid code repetition.
  local arguments = {}

  -- Re-set the arguments every time we run markmap.
  local function reset_arguments()
    arguments = {}
    if html_output ~= "" then -- if html_output is "", don't pass the parameter
      table.insert(arguments, "-o")
      table.insert(arguments, html_output)
    end
    if hide_toolbar then table.insert(arguments, hide_toolbar) end
  end

  -- Setup commands -----------------------------------------------------------
  cmd("MarkmapOpen", function()
    reset_arguments()
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
    if job ~= nil then uv.process_kill(job, 9) end
    job = uv.spawn(run_markmap, { args = arguments, detached = true }, nil)
  end, { desc = "Show a mental map of the current file" })

  cmd("MarkmapSave", function()
    reset_arguments()
    table.insert(arguments, "--no-open")           -- specific to this command
    table.insert(arguments, vim.fn.expand "%:p")   -- current buffer path
    if job ~= nil then uv.process_kill(job, 9) end -- kill -9 jobs
    job = uv.spawn(run_markmap, { args = arguments, detached = true }, nil)
  end, { desc = "Save the HTML file without opening the mindmap" })

  cmd("MarkmapWatch", function()
      reset_arguments()
      table.insert(arguments, "--watch")           -- spetific to this command
      table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
      if job ~= nil then uv.process_kill(job, 9) end
      job = uv.spawn(run_markmap, { args = arguments, detached = true }, nil)
    end,
    { desc = "Show a mental map of the current file and watch for changes" }
  )

  cmd("MarkmapWatchStop", function()
    if job ~= nil then uv.process_kill(job, 9) end -- kill -9 jobs
  end, { desc = "Manually stops markmap watch" })

  -- Autocmds --------------------------------------------------------------
  -- Kill jobs after a grace period
  local last_execution = uv.now() -- timer for grace period
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
      local current_time = uv.now()
      if current_time - last_execution >= grace_period then -- if grace period exceeded
        if job ~= nil then uv.process_kill(job, 9) end      -- pkill -9 jobs
        last_execution = current_time                       -- update time
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
end

return M
