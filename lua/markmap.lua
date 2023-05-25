-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local M = {}

M.setup = function(ctx)
  -- Setup options
  local html_output = ctx.html_output
  local hide_toolbar = ctx.hide_toolbar
  local grace_period = ctx.hide_toolbar

  -- Set default options
  if html_output == nil then
    html_output = "/tmp/markmap.html" -- by defaullt create the html file here
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
  local job

  -- Set common arguments to avoid code repetition.
  local arguments = {}
  table.insert(arguments, "markmap")
  if html_output ~= "" then -- if html_output is "", don't pass the parameter
    table.insert(arguments, "-o")
    table.insert(arguments, html_output)
  end
  if hide_toolbar then table.insert(arguments, hide_toolbar) end

  -- Setup commands -----------------------------------------------------------
  cmd("MarkmapOpen", function()
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
    if job then job.kill() end
    job = uv.spawn(comando, { detached = true }, nil)
  end, { desc = "Show a mental map of the current file" })

  cmd("MarkmapSave", function()
    table.insert(arguments, "--no-open")         -- specific to this command
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
    if job then job.kill() end
    job = uv.spawn(comando, { detached = true }, nil)
  end, { desc = "Save the HTML file without opening the mindmap" })
end

cmd("MarkmapWatch", function()
  table.insert(arguments, "--watch")           -- spetific to this command
  table.insert(arguments, vim.fn.expand "%:p") -- current buffer path
  if job then job.kill() end
  job = uv.spawn(comando, { detached = true }, nil)
end, { desc = "Show a mental map of the current file and watch for changes" })

cmd("MarkmapWatchStop", function()
  if job then job.kill() end
end, { desc = "Manually stops markmap watch" })

---- Autocmds --------------------------------------------------------------
-- Kill jobs after a grace period
local last_execution = vim.loop.now() -- timer for grace period
local autocmd_group = augroup("markmap_auto_kill_jobs", { clear = true })
autocmd("CursorHold", {
  desc = "Kill all jobs after a grace period",
  group = autocmd_group,
  callback = function()
    if current_time - last_execution >= grace_period then -- if grace period exceeded
      if job then job.kill() end                          -- kill jobs
      last_execution = current_time                       -- update time
    end
  end,
})

-- Before vim exits, we want to stop all jobs
autocmd("VimLeavePre", {
  desc = "Kill all jobs before closing vim to they don't keep running wild",
  group = autocmd_group,
  callback = function()
    if job then job.kill() end -- kill jobs
  end,
})

return M
