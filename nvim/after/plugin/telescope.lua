local ok, _ = pcall(require, "telescope")
if not ok then
  vim.notify("telescope module not found")
  return
end

-- setup

require('telescope').setup {
  defaults = {
    layout_config = {
      vertical = { width = "62%", height = "62%" }
      -- other layout configuration here
    },
    -- other defaults configuration here
  },

  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    undo = {
      use_delta = false,
      diff_context_lines = vim.o.scrolloff,
      entry_format = "#$ID, $STAT, $TIME",
      saved_only = false,
    },
  }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("undo")

-- keymaps

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fp", builtin.git_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
vim.keymap.set("n", "<leader>fq", builtin.quickfix, {})

vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
