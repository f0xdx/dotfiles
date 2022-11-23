--  helpers:  https://www.youtube.com/watch?v=ppMX4LHIuy4&t=475s (overview)
--            https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&index=1 (course)
--            https://github.com/nanotee/nvim-lua-guide
--            https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
--
-- TODO lsp-config https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- TODO treesitter https://github.com/nvim-treesitter/nvim-treesitter
-- TODO treesitter text objects https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- TODO AsyncRun https://github.com/skywind3000/asyncrun.vim
--      we need to evaluate whether this is necessary - we may just use an async
--      hook in lua and our normal qf window for my workflow - no need for all
--      the other integration in that plugin
-- TODO Toggleterm https://github.com/akinsho/toggleterm.nvim (works with
--      Asyncrun)
--      let's see whether this is required
-- TODO nvim surround https://github.com/kylechui/nvim-surround
-- TODO nvim autopairs https://github.com/windwp/nvim-autopairs
-- TODO comment plugin w/ treesitter support https://github.com/numToStr/Comment.nvim
-- TODO fzf-lua https://github.com/ibhagwan/fzf-lua
-- TODO mason for lsp management https://github.com/williamboman/mason.nvim
-- TODO lua line https://github.com/nvim-lualine/lualine.nvim
--
-- resources
--
-- guided: https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ
-- assorted: https://www.youtube.com/@teej_dv/featured

-- TODO autocmd for terminalw/o linenumbers, correct size etc.
-- https://www.youtube.com/watch?v=HR1dKKrOmDs
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
