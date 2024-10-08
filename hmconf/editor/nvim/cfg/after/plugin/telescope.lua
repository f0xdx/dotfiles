local ok, _ = pcall(require, "telescope")
if not ok then
  vim.notify("telescope module not found")
  return
end

-- setup
local actions = require("telescope.actions")

require('telescope').setup {
  defaults = {
    layout_config = {
      vertical = { width = "62%", height = "62%" }
      -- other layout configuration here
    },

    mappings = {
      i = {
        ["<C-e>"] = actions.close,
        ["<C-y>"] = actions.toggle_selection,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-e>"] = actions.close,
        ["<C-y>"] = actions.toggle_selection,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
      },
    },
  },

  extensions = {
    undo = {
      use_delta = false,
      entry_format = "#$ID, $STAT, $TIME",
      saved_only = false,
    },
    file_browser = {
      hijack_netrw = true,
      grouped = true,
    },
  }
}

require("telescope").load_extension("undo")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("zf-native")

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
vim.keymap.set("n", "<space>fd", function()
  require("telescope").extensions.file_browser.file_browser()
end)
