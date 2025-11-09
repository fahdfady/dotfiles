-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- load early with high priority, but we still call colorscheme after setup
    lazy = false,
    config = function()
      -- ensure GUI true color
      --      vim.opt.termguicolors = true

      require("kanagawa").setup({
        compile = false, -- keep it off while debugging
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        dimInactive = false,
        terminalColors = true,
        theme = "wave", -- or "dragon" / "lotus"
        overrides = function(colors)
          return {}
        end,
      })

      -- force apply after setup
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
