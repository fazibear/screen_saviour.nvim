local M = {}

M.opts = {
  after = 1 * 60,
  exclude_filetypes = { "nofile" },
  exclude_buftypes = {},
  random = {},
}

M.init = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

return M
