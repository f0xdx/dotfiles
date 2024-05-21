--------------------------------------------------------------------------------
-- TODO LSP
--
-- Options:
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
--------------------------------------------------------------------------------

require "user.options"
require "user.keymaps"
require "user.qfll"
require "user.colorscheme"
require "user.term"
require "user.org"

-- TODO write tmux based babel style plugin; name is T-Tmux R-Repl E-Emulator
-- X-eXtension ... well, also trex makes a nice logo :D
--
-- 1. check whether tmux exists and in which session we are
-- 2. create a process (for the configured tool) in a new hidden window there
-- 3. pipe input into the process inside tmux
-- 4. pipe output from that process into current buffer
--
-- use markdown as a wrapper; special comments at the top configure which
-- process we want, code blocks will be piped to a process. Example:
--
-- <!-- trex: cmd="psql $DATA_BASE_URI";block="sql;psql";format="psqlToMarkdown" -->
--
-- This will open the `psql $DATA_BASE_URI` command in a hidden window and run
-- each code block:
--
-- ```sql
-- select * from pg_catalog.pg_tables;
-- ```
-- <<< trex would insert the formatted output here>>>
--
--
-- Some hints on how this can be built
--
-- pane_id=$(tmux split-window -h -P -F "#{pane_id}")
--
-- this will give you the id of the new pane, see https://unix.stackexchange.com/questions/375567/tmux-after-split-window-how-do-i-know-the-new-pane-id
--
-- tmux send-keys -t "0.${pane_id}" "echo hello" ENTER
--
-- this will type echo hello and then run this; it is also possible to achive
-- something simliar through tmux pipe-pane, see e.g., https://www.reddit.com/r/commandline/comments/263afq/bashtmux_pipe_the_output_of_a_detached_tmux/
--
-- more holistic example (its a dettached window running an executable):
-- 
-- export TREX_WINDOW=$(tmux new-window -a -d -c "${PWD}" -e 'FOO="hello foo"' -S -n "trex" -P 'python3')
-- export TREX_PIPE_NAME="trex-${RANDOM}"
-- mkfifo "/tmp/${TREX_PIPE_NAME}"
-- tmux pipe-pane -o -t '0:3.1' "cat >> /tmp/${TREX_PIPE_NAME}"
-- cat "/tmp/${TREX_PIPE_NAME}"
--
-- now you can send keys
-- tmux send-keys -t "$TREX_WINDOW" 'print("HELLO")' ENTER
--
-- All that said, it may be much easier to simply run the process inside a
-- plenary job or system command and then read from its stdout / write to its
-- stdin.
--
-- There are also two interesting plugins
--
-- * https://github.com/Vigemus/iron.nvim
-- * https://github.com/milanglacier/yarepl.nvim

