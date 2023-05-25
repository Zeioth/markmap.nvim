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
    html_output = " -o " .. html_output
  end

  if hide_toolbar == true then
    hide_toolbar = " --no-toolbar "
  else
    hide_toolbar = ""
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
  local watch_cmd = "markmap ~/activities/2023-backlog.md"
  local handle = uv.spawn(watch_cmd, {
    stdio = { nil, uv.pipe(), uv.pipe() }, -- Redirige stdout y stderr a tuberías (pipes)
    detached = true,
  }, function(exit_code, signal)
    if exit_code == 0 then
      print "El comando se ejecutó correctamente"
    else
      print "El comando terminó con un código de salida diferente de cero"
    end
  end)

  handle.stdout:read_start() -- Descarta la salida de stdout
  handle.stderr:read_start() -- Descarta la salida de stderr
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
