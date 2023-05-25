-- open markman
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function()
  cmd("MarkmapOpen", function()
	  os.execute("markmap " .. "markmap " .. vim.fn.expand("%:p"))  end, { desc = "Show a mental map of the current file" })
  print("ALL OK")
end

return M
