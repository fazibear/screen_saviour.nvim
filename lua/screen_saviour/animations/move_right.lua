local utils = require("screen_saviour.utils")

local M = {
  fps = 30,
  name = "move_right",
}

local shift_right = function(line)
  local chars = {}
  table.insert(chars, line[#line])
  for i = 1, #line-1 do
    table.insert(chars, line[i])
  end
  return chars
end

M.update = function(grid)
  return utils.update_each(utils.is_not_space, grid, shift_right)
end

return M
