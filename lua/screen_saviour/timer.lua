local M = {}

local timer
local opts = require("screen_saviour.config").opts

M.stop = function()
  if not timer then
    return
  end
  if timer:is_active() then
    timer:stop()
  end
  if not timer:is_closing() then
    timer:close()
  end
end

M.idle = vim.schedule_wrap(function()
  if timer:is_active() then
    timer:stop()
  end
  vim.api.nvim_exec_autocmds("User", { pattern = "Idle" })
end)

M.start = function()
  if vim.tbl_contains(opts.exclude_filetypes, vim.bo.ft) then
    return
  end
  if vim.tbl_contains(opts.exclude_buftypes, vim.bo.bt) then
    return
  end

  timer = vim.loop.new_timer()

  timer:start(opts.after * 1000, 0, M.idle)
end

M.init = function()
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = M.start,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "KeyPressed",
    callback = M.stop,
  })
end

return M
