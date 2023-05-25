-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)

  -- Setup options
  html_output = ctx.html_output
  hide_toolbar = ctx.hide_toolbar

  -- bool conditions
  if (html_output == nil) then
    html_output = "/tmp/markmap.html" -- by defaullt create the html file here
  end

  if (hide_toolbar == nil) then
    hide_toolbar = ""
  end

  if (hide_toolbar == true) then
    hide_toolbar = " --no-toolbar"
  end


  -- Setup autocmds
  cmd(
  "MarkmapOpen", function()
	  os.execute("markmap " .. vim.fn.expand("%:p") .. " -o " .. html_output .. hide_toolbar)
	end, { desc = "Show a mental map of the current file" })

  cmd(
    "MarkmapSave", function()
	    os.execute("markmap " .. vim.fn.expand("%:p") .. " -o " .. html_output .. " --no-open")
	  end, { desc = "Save the HTML file without opening the mindmap" })
  end

  cmd(
    "MarkmapWatch", function()
      local cmd = "markmap " .. vim.fn.expand("%:p") .. " -o " .. html_output .. hide_toolbar .. " --watch"
	    local handle = uv.spawn(cmd) -- run async
	  end, { desc = "Show a mental map of the current file and watch for changes" }
	  )


return M
