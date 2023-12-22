local M = {}

local ui = require("screen_saviour.ui")
local timer = require("screen_saviour.timer")
local config = require("screen_saviour.config")
local manager = require("screen_saviour.manager")

M.setup = function(opts)
  config.init(opts)
  ui.init()
  manager.init()
  timer.init()
end

return M
