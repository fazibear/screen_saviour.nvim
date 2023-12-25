local M = {}

local get_dominant_hl_group = function(buffer, i, j)
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, buffer, i - 1, j - 1)
  if not ok then
    return "Normal"
  end
  for c = #captures, 1, -1 do
    if captures[c].capture ~= "spell" and captures[c].capture ~= "@spell" then
      return "@" .. captures[c].capture
    end
  end
  return "@text"
end

M.load_base_grid = function(window, buffer)
  local window_info = vim.fn.getwininfo(window)[1]
  local window_width = window_info.width - window_info.textoff
  local vertical_range = {
    start = vim.fn.line("w0") - 1,
    end_ = vim.fn.line("w$"),
  }
  local horizontal_range = {
    start = vim.fn.winsaveview().leftcol,
    end_ = vim.fn.winsaveview().leftcol + window_width,
  }

  -- initialize the grid
  local grid = {}
  for i = 1, vim.api.nvim_win_get_height(window) do
    grid[i] = {}
    for j = 1, window_width do
      grid[i][j] = { char = " ", hl_group = "" }
    end
  end
  local data = vim.api.nvim_buf_get_lines(buffer, vertical_range.start, vertical_range.end_, true)

  -- update with buffer data
  for i, line in ipairs(data) do
    for j = 1, window_width do
      local idx = horizontal_range.start + j
      if idx <= string.len(line) then
        grid[i][j].char = string.sub(line, idx, idx)
        grid[i][j].hl_group = get_dominant_hl_group(buffer, vertical_range.start + i, idx)
      end
    end
  end
  return grid
end

return M
