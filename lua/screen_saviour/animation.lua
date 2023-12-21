local M = {}

local manager = require("screen_saviour.manager")

M.all = {
  make_it_rain = require("screen_saviour.animations.make_it_rain"),
  game_of_life = require("screen_saviour.animations.game_of_life"),
  word_scramble = require("screen_saviour.animations.word_scramble"),
  word_shift_left = require("screen_saviour.animations.word_shift_left"),
  word_shift_right = require("screen_saviour.animations.word_shift_right"),
}

local get_random_animation = function()
  local keyset = {}
  for k in pairs(M.all) do
    table.insert(keyset, k)
  end
  return M.all[keyset[math.random(#keyset)]]
end

local apply_default_options = function(config)
  local default = {
    name = "",
    update = function() end,
    init = function() end,
    fps = 50,
  }
  for k, v in pairs(config) do
    default[k] = v
  end
  return default
end
M.register = function(config)
  -- "module" should implement update_grid(grid) method which takes 2D "grid"
  -- table of cells and updates it in place. Each "cell" is a table with following
  -- fields {"hl_group", "char"}
  if config.update == nil then
    error("Animation module must implement update function")
    return
  end
  if config.name == nil then
    error("Animation module must have 'name' field")
    return
  end

  M.all[config.name] = apply_default_options(config)
end

M.start = function(animation_name)
  local animation = animation_name and M.all[animation_name] or get_random_animation()
  -- Make sure animaiton exists
  if animation == nil then
    error("Error while starting an animation. Unknown screen_saviour animation: " .. animation_name)
  end

  -- Make sure nvim treesitter parser exists for current buffer
  -- if not require("nvim-treesitter.parsers").has_parser() then
  --   vim.notify("Error while starting an animation. Current buffer doesn't have associated nvim-treesitter parser.", vim.log.levels.INFO)
  --   return
  -- end

  manager.execute_animation(animation)
end

return M
