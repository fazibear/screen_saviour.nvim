local utils = require("screen_saviour.utils")

local M = {}

local get_dominant_hl_group = function(buffer, i, j)
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, buffer, i - 1, j - 1)
  if not ok then
    return "Normal"
  end
  for c = #captures, 1, -1 do
    if
      captures[c].capture ~= "spell"
      and captures[c].capture ~= "@spell"
      and string.sub(captures[c].capture, 1, 1) ~= "_"
    then
      return "@" .. captures[c].capture
    end
  end
  return "Normal"
end

local preprocess_line = function(line)
  return line:gsub("\t", string.rep(" ", vim.bo.tabstop))
end

M.load_base_grid = function(window, buffer)
  local window_info = vim.fn.getwininfo(window)[1]
  local window_width = window_info.width - window_info.textoff
  local vertical_range = {
    start = window_info.topline - 1,
    end_ = window_info.botline,
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
      grid[i][j] = { char = utils.nbsp, hl_group = "", char_start = 0, char_end = 0 }
    end
  end
  local data = vim.api.nvim_buf_get_lines(buffer, vertical_range.start, vertical_range.end_, false)

  -- update with buffer data
  for i, iline in ipairs(data) do
    local line = preprocess_line(iline)
    for j = 1, window_width do
      local idx = horizontal_range.start + j
      if idx <= utils.string_len(line) then
        grid[i][j].char = utils.string_sub(line, idx, idx)
        grid[i][j].hl_group = get_dominant_hl_group(buffer, vertical_range.start + i, idx)
      end
    end
  end

  -- update with virtual text
  local virtual_text = vim.api.nvim_buf_get_extmarks(
    buffer,
    -1,
    { vertical_range.start, horizontal_range.start },
    { vertical_range.end_ - 1, horizontal_range.end_ - 1 },
    { type = "virt_text", details = true }
  )

  for _, virt_text_data in ipairs(virtual_text) do
    local virt_row = virt_text_data[2] - vertical_range.start + 1
    local virt_col = virt_text_data[3]
    local virt_text = " " .. virt_text_data[4].virt_text[1][1]
    local virt_hl_group = virt_text_data[4].virt_text[1][2]
    for j = 1, utils.string_len(virt_text) do
      local idx = utils.string_len(data[virt_row]) + virt_col + j
      if idx <= window_width then
        grid[virt_row][idx] = {
          char = utils.string_sub(virt_text, j, j),
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
