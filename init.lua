-- open markman
local cmd = vim.api.nvim_create_user_command

cmd("MarkmapOpen", function()
	os.execute("markmap " .. "markmap " .. vim.fn.expand("%:p"))
end, { desc = "Open the current buffer using markmap-cli" })
