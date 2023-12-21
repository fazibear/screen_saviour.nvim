local M = {}

local function is_alphanumeric(c)
  return c >= "a" and c <= "z" or c >= "A" and c <= "Z" or c >= "0" and c <= "9"
end

M.update = function(grid, word_update)
  for i = 1, #grid do
    local scrambled = {}
    local word = {}
    for j = 1, #grid[i] do
      local c = grid[i][j]
      if not is_alphanumeric(c.char) then
        if #word ~= 0 then
          for _, d in pairs(word_update(word)) do
            table.insert(scrambled, d)
          end
          word = {}
        end
        table.insert(scrambled, c)
      else
        table.insert(word, c)
      end
    end

    grid[i] = scrambled
  end
  return true
end

return M
