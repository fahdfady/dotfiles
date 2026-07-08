return {
  -- Set LazyVim colorscheme to kanagawa-dragon
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },

  -- Configure gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true,
      contrast = "hard",
    },
  },

  -- Configure catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },

  -- Configure kanagawa theme (active)
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

  -- Tokyonight (moon)
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
    },
  },

  -- Bearded theme
  { "Ferouk/bearded-nvim" },

  -- Newpaper theme
  { "yorik1984/newpaper.nvim" },
}
