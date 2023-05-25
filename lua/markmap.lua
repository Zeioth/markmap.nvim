-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)
  -- Setup options
  html_output = ctx.html_output
  hide_toolbar = ctx.hide_toolbar

  -- bool conditions
  if html_output == nil then
    html_output = " -o /tmp/markmap.html " -- by defaullt create the html file here
  else
    html_output = "-o " .. html_output
  end

  if hide_toolbar == true then
    hide_toolbar = "--no-toolbar"
  else
    hide_toolbar = nil
  end

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
  table.insert(arguments, "--watch")
  table.insert(arguments, vim.fn.expand "%:p") -- current buffer path

  job
      :new({
        command = watch_cmd,
        args = arguments,
        on_exit = function(j, exit_code)
          local res = table.concat(j:result(), "\n")
          local type = "Success!"

          if exit_code ~= 0 then type = "Error!" end
          print(type, res)
        end,
      })
      :start()
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
