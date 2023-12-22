local M = {}

M.all = {
  make_it_rain = require("screen_saviour.animations.make_it_rain"),
  game_of_life = require("screen_saviour.animations.game_of_life"),
  scramble = require("screen_saviour.animations.scramble"),
  random_case = require("screen_saviour.animations.random_case"),
  move_left = require("screen_saviour.animations.move_left"),
  move_right = require("screen_saviour.animations.move_right"),
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

M.get_by_name = function(name)
  return animation_name and M.all[animation_name] or get_random_animation()
end

return M
