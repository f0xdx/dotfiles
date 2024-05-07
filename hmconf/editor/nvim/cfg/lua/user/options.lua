-- :help options

local options = {
  textwidth=80,                            -- default 80 characters wide text rows
  colorcolumn="+1",                        -- show marker at 81 column
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 1,                         -- show tabs (0 - never, 1 - more than 1, 2 - always)
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  backup = false,                          -- creates a backup file
  swapfile = false,                        -- creates a swapfile
  timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 250,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  shiftround = true,                       -- round shifts (<,>) to multiples of shiftwidth
  tabstop = 2,                             -- insert 2 spaces for a tab
  softtabstop = 2,                         -- set tabs to feel like 2 spaces (e.g., for go)
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 3,                         -- set number column width to 3 {default 4}
  foldcolumn = "1",                          -- display folds in the fold column
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 8,                           -- scroll offset
  sidescrolloff = 8,                       -- horizontal scrolling
  visualbell = true,                       -- flash instead of bing
  title = true,                            -- set terminal title
  showmatch = true,                        -- show matching braces if visible
  mat = 2,                                 -- tenths of a second to blink when showing matching brace (showmatch)
  laststatus = 3,                           -- show global status line only (default = 2)
  grepprg = "rg --vimgrep --no-heading --smart-case", -- use rg for grep
  fillchars = { eob = " ", foldopen = '', foldclose ='', fold = ' '},
}

-- optional settings

if vim.fn.has('mouse') then
  options.mouse = "a"                             -- allow the mouse to be used in neovim
end

if vim.fn.has('termguicolors') then
  options.termguicolors = true                    -- set term gui colors (most terminals support this)
end

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append "c"
vim.opt.formatoptions:remove "cro"
vim.opt.formatoptions:append "j"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

-- folding

vim.opt.foldmethod = "indent"  -- fold based on indent / treesitter has its own autocmd
vim.opt.foldnestmax = 10       -- deepest fold is 10 levels
vim.opt.foldenable = false     -- fold by default 
vim.opt.foldlevelstart = 0
vim.opt.foldlevel = 1
vim.opt.foldminlines = 2

function _G.pretty_fold_text()
  local substitute = vim.fn.substitute
  local trim = vim.fn.trim
  local line = vim.fn.getline

  local front_matter = substitute(line(vim.v.foldstart), "\\t", string.rep(" ", vim.o.softtabstop), "g")
  local back_matter = trim(line(vim.v.foldend))
  local count = vim.v.foldend - vim.v.foldstart + 1

  return front_matter  .. "   (+" .. count .. " lines)  " .. back_matter
end

vim.opt.foldtext = "v:lua.pretty_fold_text()"

-- netrw setup
-- also take a look at: https://thevaluable.dev/vim-browsing-remote-netrw/
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

-- disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- autocommand for golang source files (the only place where we need tab
-- indentation)
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  group = vim.api.nvim_create_augroup("go_file_config", { clear = true }),
  command = "setlocal ts=2 sw=2 sts=2 noexpandtab",
})
