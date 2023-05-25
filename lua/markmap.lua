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
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)

  local handle = uv.spawn(comando, {
    stdio = { nil, stdout, stderr }, -- Redirect stdout and stderr
    detached = true,
  }, function(exit_code, signal)
    if exit_code == 0 then
      print "El comando se ejecutó correctamente"
    else
      print "El comando terminó con un código de salida diferente de cero"
    end

    -- Read and display the output from stdout and stderr
    stdout:read_start(function(err, data)
      if data then print(data) end
      if err then
        -- Handle any error that occurred while reading
        print("Error reading stdout:", err)
      end
    end)

    stderr:read_start(function(err, data)
      if data then print(data) end
      if err then
        -- Handle any error that occurred while reading
        print("Error reading stderr:", err)
      end
    end)
  end)
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
