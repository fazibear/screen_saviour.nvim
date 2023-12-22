M = {}

M.is_upper = function(c)
  return c >= "A" and c <= "Z"
end

M.is_lower = function(c)
  return c >= "a" and c <= "z"
end

M.is_letter = function(c)
  return M.is_upper(c) or M.is_lower(c)
end

M.is_number = function(c)
  return c >= "0" and c <= "9"
end

M.is_alphanum = function(c)
  return M.is_letter(c) or M.is_number(c)
end

M.is_space = function(c)
  return c == " " or c == "\t"
end

M.is_not_space = function(c)
  return c ~= " " and c ~= "\t"
end

M.is_line = function(c, current_char, max_char)
  return current_char < max_char
end

M.update_each = function(conditional, grid, word_update)
  for i = 1, #grid do
    local processed = {}
    local word = {}
    for j = 1, #grid[i] do
      local c = grid[i][j]
      if conditional(c.char, j, #grid[i]) then
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
