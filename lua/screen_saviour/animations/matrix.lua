local utils = require("screen_saviour.utils")
local lines = {}
local width = 0
local height = 0
local valid_lines = {}

vim.api.nvim_set_hl(0, "Matrix", { fg = "#009900" })
vim.api.nvim_set_hl(0, "MatrixEnd", { fg = "#00FF00" })
vim.api.nvim_set_hl(0, "MatrixRnd", { fg = "#333333" })

local Line = {
  letters = "",
  position = 1,
  get_cell = function(self, l)
    if l < self.position and self.offset < l then
      if l == self.position - 1 then
        local random_char = math.random(1, utils.string_len(self.letters) or 1)
        return {
          char = utils.string_sub(self.letters, random_char, random_char),
          hl_group = "MatrixEnd",
        }
      else
        return {
          char = utils.string_sub(self.letters, l - self.offset, l - self.offset),
          hl_group = "Matrix",
        }
      end
    else
      return {
        char = string.char(math.random(33, 126)),
        hl_group = "MatrixRnd",
      }
    end
  end,
  update = function(self)
    self.position = self.position + 1
    if self.position > height or self.position > utils.string_len(self.letters) + self.offset then
      self.position = 1
      self.offset = math.random(height / 4) - 1
    end
  end,
}

function Line:new(o)
  o = o or Line
  setmetatable(o, self)
  self.__index = self
  return o
end

local create_line = function(line_data)
  local characters = ""
  for i = 1, #line_data do
    characters = characters .. line_data[i].char
  end

  characters = string.gsub(characters, "^%s+", "")
  characters = string.gsub(characters, "%s+$", "")
  characters = string.gsub(characters, utils.nbsp, "")

  return characters
end

local M = {
  name = "matrix",
  fps = 15,
}

M.init = function(grid)
  width = #grid[1]
  height = #grid

  for l = 1, height do
    local line = create_line(grid[l])

    if #line > height / 2 then
      table.insert(valid_lines, line)
    end
  end

  if #valid_lines == 0 then
    table.insert(valid_lines, "You are not working hard enough !!!")
    table.insert(valid_lines, "Don't you have anything better to do ???")
    table.insert(valid_lines, "Are you falling asleep ???")
    table.insert(valid_lines, "Wake up and do something !!!")
  end

  for l = 1, width do
    lines[l] = Line:new({
      letters = valid_lines[math.random(#valid_lines)],
      position = math.random(height),
      offset = math.random(height / 4) - 1,
    })
  end
end

M.update = function(grid)
  local char_position
  for r = 1, height do
    char_position = 0
    grid[r] = {}
    for c = 1, width do
      local new_cell = lines[c]:get_cell(r)
      new_cell.char_start = char_position
      local char_length = utils.string_byte_len(new_cell.char)
      new_cell.char_end = char_position + char_length
      grid[r][c] = new_cell
      char_position = char_position + char_length
    end
  end

  for c = 1, width do
    lines[c]:update()
  end
  return grid
end

return M
