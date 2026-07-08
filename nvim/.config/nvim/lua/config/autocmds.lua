-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function set_newpaper_rust_contrast()
  local fg = "#1d4a77"
  local groups = {
    "@type.rust",
    "@type.builtin.rust",
    "@type.definition.rust",
    "@type.enum.rust",
    "@type.struct.rust",
    "@type.qualifier.rust",
    "@constructor.rust",
    "@lsp.type.type.rust",
    "@lsp.type.enum.rust",
    "@lsp.type.struct.rust",
    "@lsp.type.class.rust",
    "@lsp.type.enumMember.rust",
    "@lsp.type.typeParameter.rust",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { fg = fg, bold = true })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "newpaper",
  callback = set_newpaper_rust_contrast,
})
