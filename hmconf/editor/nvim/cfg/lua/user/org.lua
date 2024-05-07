-- org
--
-- brings org mode like functionality to plain md note projects
local M = {}

M.make_tags = function ()
  -- (0) run external  command and pipe results asynchronously into list
  --     rg --vimgrep --no-heading -g '**/*.md' '[\s|^](#[\w|\d]+)' --trim -r '$1' -o | sort -t$':' -k4
  --
  -- (1) make new quickfix with special function for result display (tag first,
  --     then filename, line, column)
  --
  -- (2) add custom fold function to indicate one fold per tag, display the tag
  --     itself as the fold text
  --
  -- (3) ensure that folds are on for the new quickfix
end

M.setup = function (opts)
  _ = opts

  -- autocommand markdown to attach local functionality
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "markdown" },
    group = vim.api.nvim_create_augroup("md_file_config", { clear = true }),
    callback = function (_)
      local o = { noremap = true, silent = true }

      -- could add result parsing, decorators etc. and make quickfix list here;
      -- for now just grep
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ot", ":silent grep -g '**/*.md' '^\\#+ TODO.*$'<CR>", o)
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>on", ":silent grep -g '**/*.md' '^\\#+ .*$'<CR>", o)
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>o#", ":silent grep -g '**/*.md' '[\\s\\|^](\\#[\\w\\|\\d]+)' --trim -r '$1' -o<CR>", o)
      -- TODO replace this with the make tags function once available
    end
  })
end

-- after migrating to a plugin, this is what users would do
M.setup()

return M
