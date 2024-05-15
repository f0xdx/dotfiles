local colorscheme = "modus"
--
-- if os.getenv('BASE16_THEME') then
--   colorscheme = "base16-" .. os.getenv('BASE16_THEME')
-- end
--
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
--
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ebbf83", bg = "#1d252c" })
-- vim.api.nvim_set_hl(0, "FoldColumn", { link = "Comment" })

-- TODO create  a fork of https://github.com/miikanissi/modus-themes.nvim and
-- contribute this back to upstream

vim.api.nvim_set_hl(0, "@markup.strong", { link = "@text.strong" })
vim.api.nvim_set_hl(0, "@markup.italic", { link = "@text.italic" })
vim.api.nvim_set_hl(0, "@markup.link", { link = "@text.link" })
vim.api.nvim_set_hl(0, "@markup.strikethrough", { link = "@text.strikethrough" })
vim.api.nvim_set_hl(0, "@markup.heading", { link = "@text.title" })
vim.api.nvim_set_hl(0, "@markup.raw", { link = "@text.literal" })
vim.api.nvim_set_hl(0, "@markup.link", { link = "@text.reference" })
vim.api.nvim_set_hl(0, "@markup.link.url", { link = "@text.uri" })
vim.api.nvim_set_hl(0, "@markup.link.label", { link = "@string.special" })
vim.api.nvim_set_hl(0, "@markup.list", { link = "@punctuation.special" })
