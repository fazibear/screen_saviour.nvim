local utils = require("screen_saviour.utils")

local M = {
  name = "scramble",
  fps = 30,
}

local scramble = function(word)
  local chars = {}
  while #word ~= 0 do
    local index = math.random(1, #word)
    table.insert(chars, word[index])
    table.remove(word, index)
  end
  return chars
end

M.update = function(grid)
  return utils.update_each(utils.is_not_whitespace, grid, scramble)
end

return M
