if 1 ~= vim.fn.has("nvim-0.8.0") then
  vim.api.nvim_err_writeln("Cellular-automaton.nvim requires at least nvim-0.8.0")
  return
end

local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
  vim.api.nvim_err_writeln("Cellular-automaton.nvim requires nvim-treesitter/nvim-treesitter plugin to be installed.")
  return
end

if vim.g.loaded_screen_saviour == 1 then
  return
end
vim.g.loaded_screen_saviour = 1

vim.api.nvim_set_hl(0, "ScreenSaviourNormal", { default = true, link = "Normal" })

vim.api.nvim_create_user_command("ScreenSaviour", function(opts)
  require("screen_saviour.animation").start(opts.fargs[1])
end, {
  nargs = "?",
  complete = function(_, line)
    local animation_list = vim.tbl_keys(require("screen_saviour.animation").all)
    local l = vim.split(line, "%s+", {})

    if #l == 2 then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[2])
      end, animation_list)
    end
  end,
})
