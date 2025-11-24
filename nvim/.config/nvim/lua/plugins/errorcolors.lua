return {
  "rebelot/kanagawa.nvim",
  after = "kanagawa.nvim",

  config = function()
    local function set_hl(group, opts)
      vim.api.nvim_set_hl(0, group, opts)
    end

    -- Colors suited to Kanagawa Dragon theme
    local palette = {
      error = "#ffffff", -- DragonRed
      warn = "#c37d0d", -- DragonYellow
      info = "#7e9cd8", -- DragonBlue
      hint = "#6a9589", -- DragonAqua
    }

    -- Diagnostic signs (squares)
    vim.fn.sign_define("DiagnosticSignError", { text = "■", texthl = "DiagnosticError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "■", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "■", texthl = "DiagnosticInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "■", texthl = "DiagnosticHint" })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.fn.sign_define("DiagnosticSignError", { text = "■", texthl = "DiagnosticError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "■", texthl = "DiagnosticWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "■", texthl = "DiagnosticInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "■", texthl = "DiagnosticHint" })
      end,
    })
    -- Highlights
    set_hl("DiagnosticError", { fg = palette.error })
    set_hl("DiagnosticWarn", { fg = palette.warn })
    set_hl("DiagnosticInfo", { fg = palette.info })
    set_hl("DiagnosticHint", { fg = palette.hint })

    set_hl("DiagnosticUnderlineError", { undercurl = true, sp = palette.error })
    set_hl("DiagnosticUnderlineWarn", { undercurl = true, sp = palette.warn })
    set_hl("DiagnosticUnderlineInfo", { undercurl = true, sp = palette.info })
    set_hl("DiagnosticUnderlineHint", { undercurl = true, sp = palette.hint })
  end,
}
