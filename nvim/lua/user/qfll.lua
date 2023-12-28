local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap


-- quickfix

keymap("n", "[q", ":cprevious<CR>", opts)
keymap("n", "]q", ":cnext<CR>", opts)

local toggle_qf = function()
  local qfwin_id = vim.fn.getqflist({ winid = true }).winid
  if qfwin_id == 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

vim.keymap.set("n", "<leader>qq", toggle_qf, opts)
vim.keymap.set("n", "<leader>q", toggle_qf, opts)

vim.keymap.set("n", "<leader>qh", function()
  local ok, _ = pcall(function() vim.cmd("colder") end)
  if not ok then
    vim.print("[ at oldest quickfix ]")
  end
end, opts)

vim.keymap.set("n", "<leader>ql", function()
  local ok, _ = pcall(function() vim.cmd("cnewer") end)
  if not ok then
    vim.print("[ at newest quickfix ]")
  end
end, opts)

-- autocommand to attach to qf list
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "qf" },
--   group = vim.api.nvim_create_augroup("qf_file_config", { clear = true }),
--   callback = function(_)
--     local buf_opts = { noremap = true, silent = true, buffer = vim.api.nvim_buf_get_number(0) }
--
--     -- navigate through older / newer quickfixes
--   end
-- })


-- location list

keymap("n", "[l", ":lprevious<CR>", opts)
keymap("n", "]l", ":lnext<CR>", opts)

vim.keymap.set("n", "<leader>l", function()
  local ok, ll = pcall(vim.fn.getloclist, vim.api.nvim_win_get_number(0), { winid = true })
  if not ok then
    return
  end

  if ll.winid == 0 then
    pcall(function() vim.cmd("lopen") end)
  else
    pcall(function() vim.cmd("lclose") end)
  end
end, opts)
