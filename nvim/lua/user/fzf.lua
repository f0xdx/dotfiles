local fn = vim.fn
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.fzf_buffers_jump = 1  -- jump to existin buffer if possible
vim.g.fzf_history_dir = fn.expand(fn.stdpath("data") .. "/fzf-history/") -- store history here
-- vim.g.fzf_layout = { down = '40%' } -- no pop up

keymap("n", "<leader>f", ":Files<Cr>", opts)
keymap("n", "<leader>b", ":Buffers<Cr>", opts)
keymap("n", "<leader>r", ":Rg<Cr>", opts)
keymap("n", "<leader>m", ":Marks<Cr>", opts)

-- TODO neither of those seems to work - we need to somehow get the colors right
vim.g.fzf_colors = {
      ["fg"]=      {"fg", "Normal"},
      ["bg"]=      {"bg", "Normal"},
      ["hl"]=      {"fg", "Comment"},
      ["fg+"]=     {"fg", "CursorLine", "CursorColumn", "Normal"},
      ["bg+"]=     {"bg", "CursorLine", "CursorColumn"},
      ["hl+"]=     {"fg", "Statement"},
      ["info"]=    {"fg", "PreProc"},
      ["border"]=  {"fg", "Ignore"},
      ["prompt"]=  {"fg", "Conditional"},
      ["pointer"]= {"fg", "Exception"},
      ["marker"]=  {"fg", "Keyword"},
      ["spinner"]= {"fg", "Label"},
      ["header"]=  {"fg", "Comment"},
}

--vim.cmd [[
--  let g:fzf_colors =
--    \ { 'fg':      ['fg', 'Normal'],
--      \ 'bg':      ['bg', 'Normal'],
--      \ 'hl':      ['fg', 'Comment'],
--      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
--      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
--      \ 'hl+':     ['fg', 'Statement'],
--      \ 'info':    ['fg', 'PreProc'],
--      \ 'border':  ['fg', 'Ignore'],
--      \ 'prompt':  ['fg', 'Conditional'],
--      \ 'pointer': ['fg', 'Exception'],
--      \ 'marker':  ['fg', 'Keyword'],
--      \ 'spinner': ['fg', 'Label'],
--      \ 'header':  ['fg', 'Comment'] }
--]]
