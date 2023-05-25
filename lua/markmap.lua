-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)
	-- Setup options
	local html_output = ctx.html_output
	local hide_toolbar = ctx.hide_toolbar

	-- bool conditions
	if html_output == nil then
		html_output = "/tmp/markmap.html" -- by defaullt create the html file here
	end

	if hide_toolbar == nil then hide_toolbar = "" end

	if hide_toolbar == true then hide_toolbar = " --no-toolbar" end

	-- Setup autocmds
	local handle = nil -- async runner we use for watch/watchstop
	cmd(
		"MarkmapOpen",
		function()
			os.execute(
				"markmap "
				.. vim.fn.expand "%:p"
				.. " -o "
				.. html_output
				.. hide_toolbar
			)
		end,
		{ desc = "Show a mental map of the current file" }
	)

	cmd(
		"MarkmapSave",
		function()
			os.execute(
				"markmap "
				.. vim.fn.expand "%:p"
				.. " -o "
				.. html_output
				.. " --no-open"
			)
		end,
		{ desc = "Save the HTML file without opening the mindmap" }
	)

	cmd(
		"MarkmapWatch",
		function()
			-- If there was a server already running, stop it so they don't stack.
			if handle ~= nil then handle.close() end

			-- Now we can run
			local execute = "markmap "
					.. vim.fn.expand "%:p"
					.. " -o "
					.. html_output
					.. hide_toolbar
					.. " --watch"
			handle = uv.spawn(execute, {}) -- run async
		end,
		{ desc = "Show a mental map of the current file and watch for changes" }
	)

	cmd("MarkmapWatchStop", function()
		if handle ~= nil then handle.close() end
	end, { desc = "Stop the Markmap server after using watch" })

	return M
end
