local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- quickfix / locationlist navigation
keymap("n", "[l", ":lprevious<CR>", opts)
keymap("n", "]l", ":lnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)
keymap("n", "]q", ":cnext<CR>", opts)

-- toggle quickfix
vim.keymap.set("n", "<leader>q", function()
  local qfwin_id = vim.fn.getqflist({ winid = true }).winid
  if qfwin_id == 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end, opts)

-- toggle location list
vim.keymap.set("n", "<leader>l", function()
  local ok, ll = pcall(vim.fn.getloclist, vim.api.nvim_win_get_number(0), { winid = true })
  if not ok then
    return
  end

  if ll.winid == 0 then
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end, opts)
