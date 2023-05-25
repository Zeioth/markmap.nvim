-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)
  -- Setup options
  local html_output = ctx.html_output
  local hide_toolbar = ctx.hide_toolbar

  -- bool conditions
  if html_output == nil then
    html_output = "/tmp/markmap.html" -- by defaullt create the html file here
  end

  if hide_toolbar == true then
    hide_toolbar = "--no-toolbar"
  else
    hide_toolbar = nil
  end

  -- Set arguments
  local arguments = {}
  table.insert(arguments, "markmap")
  if html_output ~= "" then -- if html_output is "", don't pass the parameter
    table.insert(arguments, "-o")
    table.insert(arguments, html_output)
  end
  if hide_toolbar then table.insert(arguments, hide_toolbar) end

  -- Set job
  local job

  -- Setup autocmds
  cmd("MarkmapOpen", function()
    -- Set extra arguments
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path

    -- If a job already exists, kill it before running another one
    if job then job.kill() end

    -- Run the job
    job = uv.spawn(comando, { detached = true }, nil)
  end, { desc = "Show a mental map of the current file" })

  cmd("MarkmapSave", function()
    -- Set extra arguments
    table.insert(arguments, "--no-open")         -- specific to this command
    table.insert(arguments, vim.fn.expand "%:p") -- current buffer path

    -- If a job already exists, kill it before running another one
    if job then job.kill() end

    -- Run the job
    job = uv.spawn(comando, { detached = true }, nil)
  end, { desc = "Save the HTML file without opening the mindmap" })
end

cmd("MarkmapWatch", function()
  -- Set extra arguments
  table.insert(arguments, "--watch")           -- spetific to this command
  table.insert(arguments, vim.fn.expand "%:p") -- current buffer path

  -- If a job already exists, kill it before running another one
  if job then job.kill() end

  -- Run the job
  job = uv.spawn(comando, { detached = true }, nil)
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
