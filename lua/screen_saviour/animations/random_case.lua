local utils = require("screen_saviour.utils")

local M = {
  name = "random_case",
  fps = 10,
}

local change_char_case = function(char)
  local new_char = char
  if char.char >= "A" and char.char <= "Z" then
    new_char.char = string.lower(char.char)
  else
    new_char.char = string.upper(char.char)
  end
  return new_char
end

local change_word_case = function(word)
  local chars = {}
  local random = math.random(0, #word)
  for i = 1, #word do
    if i == random then
      table.insert(chars, word[i])
    else
      table.insert(chars, change_char_case(word[i]))
    end
  end
  return chars
end

M.update = function(grid)
  return utils.update_each(utils.is_letter, grid, change_word_case)
end

return M

