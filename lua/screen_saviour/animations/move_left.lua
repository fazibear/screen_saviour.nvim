local utils = require("screen_saviour.utils")

local M = {
  name = "move_left",
  fps = 30,
}

local shift_left = function(line)
  local chars = {}
  for i = 2, #line do
    table.insert(chars, line[i])
  end
  table.insert(chars, line[1])
  return chars
end

M.update = function(grid)
  return utils.update_each(utils.whole_line, grid, shift_left)
end

return M
