-- This plugin is a wrapper for markmap-cli
local api = vim.api
local uv = vim.uv or vim.loop
local utils = require("markmap.utils")
local jobstart = utils.jobstart
local jobstop = vim.fn.jobstop
local cmd = vim.api.nvim_create_user_command
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.setup = function(opts)
  require("markmap.config").set(opts)
  local config = vim.g.markmap_config
  local job = nil
  local arguments = {}
  local lookup_table = {}

  -- Setup commands -----------------------------------------------------------
  cmd("MarkmapOpen", function()
    config = vim.g.markmap_config
    arguments = utils.reset_arguments()
    local path = '"' .. vim.fn.expand("%:p") .. '"'  -- current buffer path
    table.insert(arguments, path)
    if job ~= nil then jobstop(job) end
    job = jobstart(config.markmap_cmd, arguments)
  end, { desc = "Show a mental map of the current file" })

  cmd("MarkmapSave", function()
    config = vim.g.markmap_config
    arguments = utils.reset_arguments()
    table.insert(arguments, "--no-open") -- specific to this command
    table.insert(arguments, vim.fn.expand("%:p")) -- current buffer path
    if job ~= nil then jobstop(job) end -- kill jobs
    job = jobstart(config.markmap_cmd, arguments)
  end, { desc = "Save the HTML file without opening the mindmap" })

  cmd(
    "MarkmapWatch",
    function()
      local watch_buffer = vim.api.nvim_get_current_buf()
      config = vim.g.markmap_config
      arguments = utils.reset_arguments()
      table.insert(arguments, "--watch") -- spetific to this command
      table.insert(arguments, vim.fn.expand("%:p")) -- current buffer path

      if lookup_table[watch_buffer] then
        vim.notify("You're already watching this buffer.", vim.log.levels.WARN)
      else
        local kill_on_close =
          augroup("markmap_kill_on_close", { clear = false })

        job = jobstart(config.markmap_cmd, arguments, {
          stderr_buffered = true, -- needed so on_stderr is only called once
          on_stderr = function(_, data)
            local message = table.concat(data, "\n")
            message = message:gsub("\r", "")
            vim.notify(message, vim.log.levels.ERROR)

            lookup_table[watch_buffer] = nil
            api.nvim_clear_autocmds({
              group = kill_on_close,
              buffer = watch_buffer,
            })
          end,
        })

        lookup_table[watch_buffer] = job

        -- Register buffer local autocmd to kill job when buffer closes
        autocmd("BufDelete", {
          desc = "Kill markmap when watched buffer is closed",
          buffer = watch_buffer,
          group = kill_on_close,
          callback = function()
            jobstop(job)
            lookup_table[watch_buffer] = nil
            api.nvim_clear_autocmds({
              group = kill_on_close,
              buffer = watch_buffer,
            })
          end,
        })
      end
    end,
    { desc = "Show a mental map of the current file and watch for changes" }
  )

  cmd("MarkmapWatchStop", function()
    local watch_buffer = vim.api.nvim_get_current_buf()
    local job = lookup_table[watch_buffer]
    if job then
      jobstop(job)
      lookup_table[watch_buffer] = nil
      api.nvim_clear_autocmds({
        group = kill_on_close,
        buffer = watch_buffer,
      })
    end
  end, { desc = "Manually stops markmap watch" })
end

return M
