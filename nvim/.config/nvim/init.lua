-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd([[
augroup kitty_mp
    autocmd!
    au VimLeave * :silent !kitty @ set-spacing padding=0 margin=21.75
    au VimEnter * :silent !kitty @ set-spacing padding=0 margin=0
augroup END
]])
