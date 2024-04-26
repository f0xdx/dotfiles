local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap


-- TODO make [q and ]q cycle through the quickfix lists
-- TODO make [q and ]q cycle through the location list lists

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

-- -- qf_filename extracts the name of a file from the default quickfix expression
local function qf_filename(line)
  return vim.fn.substitute(line, "|.*$", "", "")
end
--
-- -- fold_qf_expr defines a foldexpr for use in quick fix windows. It will define
-- -- folds by filename, grouping similar folds together
function _G.fold_qf_expr()
  local file = qf_filename(vim.fn.getline(vim.v.lnum))

  if file == nil or file == "" then
    return -1
  end

  if file ~= qf_filename(vim.fn.getline(vim.v.lnum - 1)) then
    return ">1"
  end

  return "="
end

-- -- autocommand to attach to qf list
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "qf" },
--   group = vim.api.nvim_create_augroup("qf_file_config", { clear = true }),
--   callback = function(ev)
--     -- local buf_opts = { noremap = true, silent = true, buffer = vim.api.nvim_buf_get_number(0) }
--     -- might need window local setting, see https://github.com/ashfinal/qfview.nvim/blob/main/lua/qfview/init.lua :
--     local qf_winid = vim.fn.bufwinnr(ev.buf)
--
--     -- TODO this errors as there is not necessarily an open window yet
--     vim.api.nvim_win_set_option(qf_winid, "foldmethod", "expr")
--     vim.api.nvim_win_set_option(qf_winid, "foldexpr", "v:lua.fold_qf_expr()")
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
