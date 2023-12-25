if 1 ~= vim.fn.has("nvim-0.8.0") then
  vim.api.nvim_err_writeln("screen_saviour.nvim requires at least nvim-0.8.0")
  return
end

if vim.g.loaded_screen_saviour == 1 then
  return
end

vim.g.loaded_screen_saviour = 1

vim.api.nvim_set_hl(0, "ScreenSaviourNormal", { default = true, link = "Normal" })

local start = vim.schedule_wrap(function(opts)
  require("screen_saviour.manager").start(opts.fargs[1])
end)

local complete = function(_, line)
  local animation_list = vim.tbl_keys(require("screen_saviour.animation").all)
  local l = vim.split(line, "%s+", {})

  if #l == 2 then
    return vim.tbl_filter(function(val)
      return vim.startswith(val, l[2])
    end, animation_list)
  end
end

vim.api.nvim_create_user_command("ScreenSaviour", start, { nargs = "?", complete = complete })
