M = {}

M.get_char = function(grid, i, j)
  local c = grid[i][j]
  if c then
    return c.char
  else
    return ""
  end
end

M.is_upper = function(grid, i, j)
  return M.get_char(grid, i, j) >= "A" and M.get_char(grid, i, j) <= "Z"
end

M.is_lower = function(grid, i, j)
  return M.get_char(grid, i, j) >= "a" and M.get_char(grid, i, j) <= "z"
end

M.is_letter = function(grid, i, j)
  return M.is_upper(grid, i, j) or M.is_lower(grid, i, j)
end

M.is_number = function(grid, i, j)
  return M.get_char(grid, i, j) >= "0" and M.get_char(grid, i, j) <= "9"
end

M.is_alphanum = function(grid, i, j)
  return M.is_letter(grid, i, j) or M.is_number(grid, i, j)
end

M.is_space = function(grid, i, j)
  return M.get_char(grid, i, j) == " " or M.get_char(grid, i, j) == "\t"
end

M.is_not_space = function(grid, i, j)
  return not M.is_space(grid, i, j)
end

M.whole_line = function(grid, i, j)
  return not (M.is_space(grid, i, j) and (M.is_space(grid, i, j-1) or M.is_space(grid, i, j+1)))
end
--
-- M.is_line = function(char, next_char, current_char_index, max_char_index)
--   return char ~= " " and next_char ~= " "
-- --    current_char_index < max_char_index
-- end

M.update_each = function(conditional, grid, word_update)
  for i = 1, #grid do
    local processed = {}
    local word = {}
    for j = 1, #grid[i] do
      local c = grid[i][j]
      if conditional(grid, i, j) then
        table.insert(word, c)
      else
        if #word ~= 0 then
          for _, d in pairs(word_update(word)) do
            table.insert(processed, d)
          end
          word = {}
        end
        table.insert(processed, c)
      end
    end

    grid[i] = processed
  end
  return true
end

return M