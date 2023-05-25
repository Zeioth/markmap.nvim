-- open markman
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function()

  -- Setup autocmd
  cmd("MarkmapOpen", function()
	  os.execute("markmap " .. vim.fn.expand("%:p") .. " -o /tmp/markmap.html" )  end, { desc = "Show a mental map of the current file" })
  end

return M
