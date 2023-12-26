local utils = require("screen_saviour.utils")

local M = {
  name = "move_right",
  fps = 30,
}

local shift_right = function(line)
  local chars = {}
  table.insert(chars, line[#line])
  for i = 1, #line - 1 do
    table.insert(chars, line[i])
  end
  return chars
end

M.update = function(grid)
  return utils.update_each(utils.whole_line, grid, shift_right)
end

return M
