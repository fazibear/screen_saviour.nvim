local utils = require("screen_saviour.utils")
local lines = {}
local width = 0
local height = 0
local valid_lines = {}

local Line = {
  letters = {},
  position = 1,
  get_cell = function(self, l)
    if l < self.position and self.offset < l then
      return self.letters[l - self.offset]
    else
      return { char = " ", hl_group = "" }
    end
  end,
  update = function(self)
    self.position = self.position + 1
    if self.position > height or self.position > #self.letters + self.offset then
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

local is_whitespace = function(c)
  return c == " " or c == utils.nbsp
end

local create_line = function(line_data)
  local first_char = 0
  local last_char = #line_data

  for i = 1, #line_data do
    if not is_whitespace(line_data[i].char) then
      first_char = i
      break
    end
  end

  if first_char == 0 then
    return {}
  end

  for i = #line_data, 1, -1 do
    if not is_whitespace(line_data[i].char) then
      last_char = i
      break
    end
  end

  local new_line = {}
  for i = first_char, last_char do
    table.insert(new_line, line_data[i])
  end
  return new_line
end

local M = {
  name = "rain",
  fps = 30,
}

M.init = function(grid)
  width = #grid[1]
  height = #grid

  for l = 1, height do
    local line = create_line(grid[l])

    if #line > height / 2 and line ~= {} then
      table.insert(valid_lines, line)
    end
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
  for r = 1, height do
    grid[r] = {}
    for c = 1, width do
      if c % 2 == 0 then
        grid[r][c] = { char = " ", hl_group = "" }
      else
        grid[r][c] = lines[c]:get_cell(r)
      end
    end
  end
  for c = 1, width do
    lines[c]:update()
  end
  return grid
end

return M
