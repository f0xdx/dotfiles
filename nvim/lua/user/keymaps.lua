local opts = { noremap = true, silent = true }
local term_opts = { silent = true } -- do we need this?
local keymap = vim.api.nvim_set_keymap

-- leader key config
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- Normal --
-- window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- window resize
keymap("n", "<C-w><C-k>", ":resize +5<CR>", opts)
keymap("n", "<C-w><C-j>", ":resize -5<CR>", opts)
keymap("n", "<C-w><C-h>", ":vertical resize -5<CR>", opts)
keymap("n", "<C-w><C-l>", ":vertical resize +5<CR>", opts)

-- tmux style splits
keymap("n", "<C-w>%", ":vspl<cr>", opts)
keymap("n", "<C-w>\"", ":spl<cr>", opts)

-- netrw as explorer
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- easily remove highlights
keymap("n", "<Esc><Esc>", ":nohls<CR>", opts)


-- Insert --

-- press jk fast to exit
keymap("i", "jk", "<ESC>", opts)
keymap("i", "<C-Space>", "<C-x><C-o>", opts)


-- Visual --

-- stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)


-- Visual Block --

-- move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --

-- better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
