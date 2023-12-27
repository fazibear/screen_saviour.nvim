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
      grid[i][j] = { char = " ", hl_group = "" } -- <- &nbsp;
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

  -- update with virtual text
  local virtual_text = vim.api.nvim_buf_get_extmarks(
    buffer,
    -1,
    { vertical_range.start, horizontal_range.start },
    { vertical_range.end_, horizontal_range.end_ },
    { type = "virt_text", details = true }
  )

  for _, virt_text_data in ipairs(virtual_text) do
    local virt_row = virt_text_data[2] - vertical_range.start + 1
    local virt_col = virt_text_data[3]
    local virt_text = " " .. virt_text_data[4].virt_text[1][1]
    local virt_hl_group = virt_text_data[4].virt_text[1][2]
    for j = 1, string.len(virt_text) do
      local idx = string.len(data[virt_row]) + virt_col + j
      if idx <= window_width then
        grid[virt_row][idx] = {
          char = string.sub(virt_text, j, j),
          hl_group = virt_hl_group,
        }
      end
    end
  end

  -- local virtual_lines = vim.api.nvim_buf_get_extmarks(
  --   buffer,
  --   -1,
  --   { vertical_range.start, horizontal_range.start },
  --   { vertical_range.end_, horizontal_range.end_ },
  --   { type = "virt_lines", details = true }
  -- )

  return grid
end

return M
