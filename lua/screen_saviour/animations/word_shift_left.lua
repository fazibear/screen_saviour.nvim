word_update = require("screen_saviour.animations.word").update

local M = {
  fps = 15,
  name = "word_shift_left",
}

local shift_left = function(word)
  local chars = {}
  for i = 2, #word do
    table.insert(chars, word[i])
  end
  table.insert(chars, word[1])
  return chars
end

M.update = function(grid)
  return word_update(grid, shift_left)
end

return M
