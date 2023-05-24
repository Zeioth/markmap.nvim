-- open markman
local cmd = vim.api.nvim_create_user_command

cmd("MarkmapOpen", function()
	os.execute("markmap " .. vim.api.nvim_get_current_buf(bufnr))
end, { desc = "cd current file's directory" })
