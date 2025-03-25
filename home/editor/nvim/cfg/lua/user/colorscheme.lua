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

