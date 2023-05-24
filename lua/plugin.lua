-- open markman
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function()
  cmd("MarkmapOpen", function()
  	os.execute("markmap " .. vim.api.nvim_get_current_buf(bufnr))
  end, { desc = "cd current file's directory" })
end

return M.setup()
