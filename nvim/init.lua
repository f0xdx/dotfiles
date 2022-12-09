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
-- TODO FZF
--
-- current version uses the old fzf.vim plugin which is written mostly in
-- synchronouse vim script (color configuration doesn't really work for the
-- external previewer either). We need to replace this with something
-- easier / faster, preview for external files not required (rg and buffers
-- would be good)
--
-- Options
--  - fzy with custom integration (like: https://www.chrisdeluca.me/article/diy-neovim-fzy-search/ )
--    or fzy-nvim https://github.com/mfussenegger/nvim-fzy
--  - telescope with fzy native (really?)
--  - https://github.com/vijaymarupudi/nvim-fzf (with hand rolled commands)
--------------------------------------------------------------------------------
-- TODO LSP
--
-- Options:
--  - add loc list and qf list toggles, something like https://rafaelleru.github.io/blog/quickfix-autocomands/
--  - null-ls for formatting, linting and generic code action support
--
--------------------------------------------------------------------------------
-- TODO Status Line
--
-- Integrate diagnostics and LSP status (?) into EL
-- Options
--  - lsp status integration https://github.com/nvim-lua/lsp-status.nvim
--
--------------------------------------------------------------------------------
-- TODO Other 
--
--  - AsyncRun https://github.com/skywind3000/asyncrun.vim
--    we need to evaluate whether this is necessary - we may just use an async
--    hook in lua and our normal qf window for my workflow - no need for all
--    the other integration in that plugin
--------------------------------------------------------------------------------

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
