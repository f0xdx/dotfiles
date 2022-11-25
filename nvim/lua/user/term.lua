-- autocommand group to use termina more easily
local term_group = vim.api.nvim_create_augroup("packer_user_config", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "*" },
  group = term_group,
  command = "startinsert",
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "*" },
  group = term_group,
  callback = function() 
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

