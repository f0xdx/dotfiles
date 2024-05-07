-- autocommand group to use termina more easily
local term_group = vim.api.nvim_create_augroup("term_user_config", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "*" },
  group = term_group,
  command = "startinsert",
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "*" },
  group = term_group,
  callback = function() 
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
