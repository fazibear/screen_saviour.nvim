word_update = require("screen_saviour.animations.word").update

local M = {
  fps = 15,
  name = "word_shift_right",
}

local shift_right = function(word)
  local chars = {}
  table.insert(chars, word[#word])
  for i = 1, #word-1 do
    table.insert(chars, word[i])
  end
  return chars
end

M.update = function(grid)
  return word_update(grid, shift_right)
end

return M
