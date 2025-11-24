return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Higher than others
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        compile = false,
        terminalColors = false,
        overrides = function(colors)
          return {}
        end,
      })

      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
}
