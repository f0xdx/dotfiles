--  helpers:  https://www.youtube.com/watch?v=ppMX4LHIuy4&t=475s (overview)
--            https://github.com/nanotee/nvim-lua-guide
--            https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ
--            https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
--            https://www.youtube.com/@teej_dv/featured
--            https://www.youtube.com/watch?v=HR1dKKrOmDs
--
--------------------------------------------------------------------------------
-- TODO Integration
-- - create terminal with correct size etc
-- - toggle terminal window keeping term open
--
--------------------------------------------------------------------------------
-- TODO LSP
--
-- Options:
--  - lsp-config https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
--  - optional: mason for lsp management https://github.com/williamboman/mason.nvim
--  - add loc list and qf list toggles, something like https://rafaelleru.github.io/blog/quickfix-autocomands/
--
--------------------------------------------------------------------------------
-- TODO treesitter 
--
-- Options
--  - https://github.com/nvim-treesitter/nvim-treesitter
--  - treesitter text objects https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--------------------------------------------------------------------------------
-- TODO Convenience
--
-- Options
--  - nvim surround https://github.com/kylechui/nvim-surround
--  - nvim autopairs https://github.com/windwp/nvim-autopairs
--  - comment plugin w/ treesitter support https://github.com/numToStr/Comment.nvim
--
--------------------------------------------------------------------------------
-- TODO Status Line
--
-- Need to decide forstatus line: decide hand rolled vs. full featured
-- (e.g., lua line)
--
-- Options
--  - lsp status integration https://github.com/nvim-lua/lsp-status.nvim
--  - lua line https://github.com/nvim-lualine/lualine.nvim
--
--------------------------------------------------------------------------------
-- TODO Other 
--
--  - AsyncRun https://github.com/skywind3000/asyncrun.vim
--    we need to evaluate whether this is necessary - we may just use an async
--    hook in lua and our normal qf window for my workflow - no need for all
--    the other integration in that plugin
--  - Toggleterm https://github.com/akinsho/toggleterm.nvim (works with
--    Asyncrun) let's see whether this is required
--
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.term"

-- autocommand for syncing packer on any changes to the plugins file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "plugins.lua" },
  group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
  command = "source <afile> | PackerSync",
})
