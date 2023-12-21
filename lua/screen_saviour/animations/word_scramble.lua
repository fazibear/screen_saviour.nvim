word_update = require("screen_saviour.animations.word").update

local M = {
  fps = 30,
  name = "word_scramble",
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
  return word_update(grid, scramble)
end

return M
