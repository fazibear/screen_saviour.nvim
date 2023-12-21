local M = {}
local timer
local default_opts = {
  after = 60,
  exclude_filetypes = {},
  exclude_buftypes = {},
}
local animation = require("cellular-automaton.animation")
local ui = require("cellular-automaton.ui")

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  vim.on_key(ui.on_key)

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function()
      if vim.tbl_contains(opts.exclude_filetypes, vim.bo.ft) then return end
      if vim.tbl_contains(opts.exclude_buftypes, vim.bo.bt) then return end

      timer = vim.loop.new_timer()
      timer:start(opts.after * 1000, 0, vim.schedule_wrap(function()
        if timer:is_active() then timer:stop() end
        vim.schedule(function()
          vim.api.nvim_exec_autocmds("User", { pattern = "Idle" })
        end)
      end))

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        callback = function()
          if timer:is_active() then timer:stop() end
          if not timer:is_closing() then timer:close() end
        end,
        once = true
      })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "Idle",
    callback = animation.start
  })
end

return M
