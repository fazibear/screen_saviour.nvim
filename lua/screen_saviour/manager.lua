local M = {}

local common = require("screen_saviour.common")
local ui = require("screen_saviour.ui")
local animation = require("screen_saviour.animation")

local animation_in_progress = false

local function process_frame(grid, animation_config, win_id)
  if win_id == nil or not vim.api.nvim_win_is_valid(win_id) then
    return
  end
  -- proccess frame
  ui.render_frame(grid)
  local render_at = common.time()
  local state_changed = animation_config.update(grid)

  -- schedule next frame
  local fps = animation_config.fps or 50
  local time_since_render = common.time() - render_at
  local timeout = math.max(0, 1000 / fps - time_since_render)
  if state_changed then
    vim.defer_fn(function()
      process_frame(grid, animation_config, win_id)
    end, timeout)
  end
end

local function setup_cleaning(win_id, _buffers)
  vim.api.nvim_create_autocmd("WinClosed", {
    group = vim.api.nvim_create_augroup("CellularAutomoton", { clear = true }),
    pattern = tostring(win_id),
    callback = M.clean,
  })
end

M.start = function(animation_name)
  if animation_in_progress then
    vim.print("Animation is already in progress")
    M.clean()
    return 
  end
  
  animation_in_progress = true
  
  local animation = animation.get_by_name(animation_name)
  local host_win_id = vim.api.nvim_get_current_win()
  local host_bufnr = vim.api.nvim_get_current_buf()
  local grid = require("screen_saviour.load").load_base_grid(host_win_id, host_bufnr)
  
  vim.print("Starting animation: " .. animation.name)

  if animation.init ~= nil then
    animation.init(grid)
  end
  local win_id, buffers = ui.open_window(host_win_id)
  process_frame(grid, animation, win_id)
  setup_cleaning(win_id, buffers)
end

M.init = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "Idle",
    callback = M.start
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "KeyPressed",
    callback = M.clean
  })
end

M.clean = function()
  animation_in_progress = false
  ui.clean()
end

return M
