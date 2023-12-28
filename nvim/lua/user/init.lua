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
-- TODO AsyncRun https://github.com/skywind3000/asyncrun.vim
--   we need to evaluate whether this is necessary - we may just use an async
--   hook in lua and our normal qf window for my workflow - no need for all
--   the other integration in that plugin
--
-- TODO Orgmode https://github.com/nvim-orgmode/orgmode
--  This is neat for note taking and can even be extend to have jupyter notebook
--  like repl setup. Need to evaluate how this is better than normal files +
--  grep / telescope
--
--------------------------------------------------------------------------------

require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.qfll"
require "user.colorscheme"
require "user.term"
require "user.org"
