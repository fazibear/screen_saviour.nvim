local M = {}

M.opts = {
  after = 30,
  exclude_filetypes = { "nofile" },
  exclude_buftypes = {},
}

M.init = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

return M
