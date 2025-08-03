-- This plugin is a wrapper for markmap-cli
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
    local path = '"' .. vim.fn.expand("%:p") .. '"' -- current buffer path
    table.insert(arguments, "--no-open")            -- specific to this command
    table.insert(arguments, path)
    if job ~= nil then jobstop(job) end             -- kill jobs
    job = jobstart(config.markmap_cmd, arguments)
  end, { desc = "Save the HTML file without opening the mindmap" })

  cmd("MarkmapWatch", function()
    config = vim.g.markmap_config
    arguments = utils.reset_arguments()
    local path = '"' .. vim.fn.expand("%:p") .. '"' -- current buffer path
    table.insert(arguments, "--watch")              -- spetific to this command
    table.insert(arguments, path)
    if job ~= nil then jobstop(job) end             -- kill jobs
    job = jobstart(config.markmap_cmd, arguments)
  end, { desc = "Show a mental map of the current file and watch for changes" })

  cmd("MarkmapWatchStop", function()
    if job ~= nil then jobstop(job) end             -- kill jobs
  end, { desc = "Manually stops markmap watch" })

  -- Autocmds -----------------------------------------------------------------
  -- Kill jobs after a grace period
  local last_execution = vim.uv.now() -- timer for grace period
  autocmd("CursorHold", {
    desc = "Kill all markmap jobs after a grace period",
    group = augroup("markmap_kill_after_grace_period", { clear = true }),
    callback = function()
      -- If grace_period is disabled, remove the autocmd and return
      if config.grace_period == 0 then
        vim.cmd "autocmd! markmap_kill_after_grace_period"
        return
      end

      -- Otherwise, use grace_period
      local current_time = vim.uv.now()
      if current_time - last_execution >= config.grace_period then -- if grace period exceeded
        if job ~= nil then jobstop(job) end                        -- pkill jobs
        last_execution = current_time                              -- update time
      end
    end,
  })
end

return M
