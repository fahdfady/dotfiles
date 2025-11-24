-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- only for diagnostics. The rest of LSP support will still be
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight NormalNC guibg=none
  highlight SignColumn guibg=none
  highlight LineNr guibg=none
  highlight Folded guibg=none
  highlight EndOfBuffer guibg=none
]])

vim.o.shell = "fish"
