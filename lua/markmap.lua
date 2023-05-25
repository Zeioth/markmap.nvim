-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)
  -- Setup options
  html_output = ctx.html_output
  hide_toolbar = ctx.hide_toolbar

  -- bool conditions
  if html_output == nil or html_output == "" then
    html_output = "/tmp/markmap.html" -- by defaullt create the html file here
  end

  if hide_toolbar == true then
    hide_toolbar = "--no-toolbar"
  else
    hide_toolbar = nil
  end

  -- Global job
  local job

  -- Setup autocmds
  cmd(
    "MarkmapOpen",
    function()
      os.execute(
        "markmap " .. html_output .. hide_toolbar .. vim.fn.expand "%:p"
      )
    end,
    { desc = "Show a mental map of the current file" }
  )

  cmd(
    "MarkmapSave",
    function()
      os.execute(
        "markmap " .. html_output .. " --no-open " .. vim.fn.expand "%:p"
      )
    end,
    { desc = "Save the HTML file without opening the mindmap" }
  )
end

cmd("MarkmapWatch", function()
  local watch_cmd = "markmap"
  local job = require "plenary.job"

  -- Set arguments
  local arguments = {}
  table.insert(arguments, "-o")
  table.insert(arguments, html_output)
  if hide_toolbar then table.insert(arguments, hide_toolbar) end
  table.insert(arguments, "--watch")
  table.insert(arguments, vim.fn.expand "%:p") -- current buffer path

  -- If job already exists, kill it before running another one
  if job then job.kill() end

  -- Run the job
  local job = uv.spawn(comando, { detached = true }, nil)
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
