return {
  -- Set LazyVim colorscheme to kanagawa-dragon
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },

  -- Configure kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "dragon",
      compile = false,
      terminalColors = true,
    },
  },
}
