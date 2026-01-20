-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true

-- Hide the status bar completely
vim.opt.laststatus = 0

-- Optional: Hide the command line (cmdheight) if you want it TRULY minimal
vim.opt.cmdheight = 0


-- Change the Tab character from ">" to a vertical line "│" or just a space
vim.opt.listchars = {
  tab = "│ ", -- Makes tabs look like indent guides
  -- tab = "  ", -- Alternative: makes tabs invisible
  trail = "·", -- Shows trailing spaces as dots
  extends = "…",
  precedes = "…",
  nbsp = "␣",
}
