-- org
--
-- brings org mode like functionality to plain md note projects

local opts = { noremap = true, silent = true }

-- autocommand markdown to attach local functionality
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  group = vim.api.nvim_create_augroup("md_file_config", { clear = true }),
  callback = function (_)
    -- could add result parsing, decorators etc. and make quickfix list here;
    -- for now just grep
    vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ot", ":silent grep -g '**/*.md' '^\\#+ TODO.*$'<CR>", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "<localleader>on", ":silent grep -g '**/*.md' '^\\#+ .*$'<CR>", opts)
  end
})
