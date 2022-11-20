" init.vim
"
" Turns neovim into a fully featured modern editor tailored to
" my workflow.
"
" requirements:
"
"  * 256 color terminal 
"  * nerdfont, e.g., Fira Code NF or Hack NF
"  * neovim
"  * fzf 
"  * lf
"  * ripgrep (otional)
"  * bat (otional)
"  * delta (otional)

" {{{ platform config
  if (has('nvim'))
    " show results of substition as they're happening
    " but don't open a split
    set inccommand=nosplit
  endif
  if has('mouse')
    set mouse=a
  endif

  set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
  if &term =~ '256color'
    " disable background color erase
    set t_ut=
  endif

  " enable 24 bit color support if supported
  if (has("termguicolors"))
    if (!(has("nvim")))
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
  endif
" }}}

" plugins

call plug#begin(expand(stdpath('config') . '/plugged'))

  " {{{ basic config
    Plug 'tpope/vim-sensible' " sensible default settings for nvim

    set textwidth=80
    set colorcolumn=81
    set encoding=utf8
    set spelllang=en,de
    set splitright
    set splitbelow

    " searching
    set ignorecase   " case insensitive searching
    set smartcase    " case-sensitive if expresson contains a capital letter
    set hlsearch     " highlight search results
    set nolazyredraw " don't redraw while executing macros
    set magic        " Set magic on, for regex

    " error bells
    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500

    " appearance
    set number                " show line numbers
    set nowrap                " turn on line wrapping
    set wrapmargin=2          " wrap lines when coming within n characters from side
    set linebreak             " set soft wrapping
    set ttyfast               " faster redrawing
    set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff
    set so=7                  " set 7 lines to the cursors - when moving vertical
    set hidden                " current buffer can be put into background
    set showcmd               " show incomplete commands
    set noshowmode            " don't show which mode disabled for PowerLine
    " set wildmode=list:longest " complete files like a shell
    set cmdheight=1           " command bar height
    set cursorline            " highlight current line
    set title                 " set terminal title
    set showmatch             " show matching braces
    set mat=2                 " how many tenths of a second to blink
    set updatetime=300
    set signcolumn=yes
    set shortmess+=c
    set formatoptions+=j      " delete comment character when joining commented lines
    set shell=$SHELL

    " tabs
    set tabstop=2     " the visible width of tabs
    set softtabstop=2 " edit as if the tabs are 2 characters wide
    set shiftwidth=2  " number of spaces to use for indent and unindent
    set expandtab     " expand tab to 2 space
    set shiftround    " round indent to a multiple of 'shiftwidth'

    " code folding settings
    set foldmethod=syntax " fold based on syntax
    set foldnestmax=10    " deepest fold is 10 levels
    set foldenable        " fold by default (no folde: nofoldenable)
    set foldlevelstart=1
    set foldlevel=1

    " editing settings for this file
    augroup initvim
      autocmd BufRead init.vim,.vimrc set foldmethod=marker foldlevel=0
      autocmd BufWritePost init.vim,.vimrc source %
    augroup END

    " toggle invisible characters
    " set list
    set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪

    " terminal
    if has('nvim')
      tnoremap <A-Space> <C-\><C-n>
    endif
    augroup neovim_terminal
      autocmd!
      " Enter Terminal-mode (insert) automatically
      autocmd TermOpen * startinsert
      " Disables number lines on terminal buffers
      autocmd TermOpen * :set nonumber norelativenumber
    augroup END

    autocmd BufNewFile,BufRead *.go setlocal ts=2 sw=2 sts=2 noexpandtab
  " }}}

  " {{{ added comfort (surround, repeat, commentary, git etc.)
    Plug 'junegunn/vim-easy-align' " align text visually
    Plug 'tpope/vim-repeat'        " repeat plugin actions with .
    Plug 'tpope/vim-commentary'    " toggle comments (gcc and friends)
    Plug 'tpope/vim-ragtag'        " endings for html, xml, etc. - ehances surround
    Plug 'tpope/vim-surround'      " surround motions with ( etc.
    Plug 'tpope/vim-endwise'       " add end, endif, etc. automatically
    Plug 'tpope/vim-sleuth'        " detect indentation config etc. automatically
    Plug 'jiangmiao/auto-pairs'    " never forget a closing parenthesis

    Plug 'voldikss/vim-floaterm'   " floating terminal windows
                                   " netrw fine tuning
    Plug 'tpope/vim-vinegar'       " improve netrw (file explorer) setup

    let g:netrw_liststyle = 3      " use tree view
    let g:netrw_browse_split = 4   " open files in previous window

    let g:AutoPairsMapSpace=0
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
  " }}}

  " {{{ dev setup (git, testing, etc.)
    Plug 'skywind3000/asyncrun.vim' " async running of tasks, e.g., make and friends
    Plug 'tpope/vim-fugitive'       " git support, alternative: https://github.com/jreybert/vimagit
    
    " {{{ markdown support
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
    " }}}
    Plug 'hashivim/vim-terraform'
  " }}}
  
  " {{{ fzf + rgrep
    Plug 'junegunn/fzf', { 'dir': expand(stdpath('config') . '/fzf/'), 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'

    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " let g:fzf_layout = { 'window': 'enew' }
    " let g:fzf_layout = { 'window': '-tabnew' }
    " let g:fzf_layout = { 'window': '10new' }

    " Customize fzf colors to match your color scheme
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = expand(stdpath('data') . '/fzf-history/')

    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    let $FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
  " TODO improve fzf configuration similarly to https://github.com/nicknisi/dotfiles/blob/master/config/nvim/init.vim
  " }}}
  
  " {{{ LSP and code completion
    " TODO add nvim-cmp https://github.com/hrsh7th/nvim-cmp
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip' 
    Plug 'onsails/lspkind-nvim'     " add icons showing the completion source
    Plug 'ray-x/lsp_signature.nvim' " display hints on function signature
    Plug 'nanotee/sqls.nvim'        " sqls is configured with the lsp, this add relevant commands
  " }}}

  " TODO nvm-lint + configuration: https://github.com/mfussenegger/nvim-lint
  " TODO check whether to use multiple cursors: Plug 'terryma/vim-multiple-cursors'
  " TODO check inspiration at
  "  * https://github.com/zenbro/dotfiles/blob/master/.nvimrc
  "  * https://github.com/nicknisi/dotfiles/blob/master/config/nvim/init.vim"
  " TODO exchange the custom lsp setup we do with https://github.com/ray-x/navigator.lua
  "      (which brings required integrations out of the box)
  
  " {{{ keybindings
    let mapleader="\<space>"
    " nnoremap <silent> <leader><leader> :Explore<Cr>
    nnoremap <silent> <leader><leader> :FloatermNew xplr<Cr>
    nnoremap <silent> <leader>c :Commands<Cr>
    nnoremap <silent> <leader>f :Files<Cr>
    nnoremap <silent> <leader>b :Buffers<Cr>
    nnoremap <silent> <leader>l :Lines<Cr>
    nnoremap <silent> <leader>L :BLines<Cr>
    nnoremap <silent> <leader>m :Marks<Cr>
    nnoremap <silent> <leader>t :Tags<Cr>
    nnoremap <silent> <leader>T :BTags<Cr>
    nnoremap <silent> <leader>r :Rg<Cr>
    nnoremap <silent> <leader>gf :GitFiles<Cr>
    nnoremap <silent> <leader>gc :Commits<Cr>
    nnoremap <silent> <leader>gC :BCommits<Cr>
    nnoremap <silent> <leader>" :FloatermNew<Cr>
    nnoremap <silent> <C-w>% :vsplit<Cr>
    nnoremap <silent> <C-w>" :split<Cr>
    " TODO maybe something like that as well https://rafaelleru.github.io/blog/quickfix-autocomands/
    " (toggle quickfix, location list)
  "}}}
  
  " {{{ appearance (base16, airline, devicons)
    Plug 'base16-project/base16-vim' " base 16 themes
    Plug 'vim-airline/vim-airline'   " airline for overview
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'    " add icons to different filetypes
    Plug 'edkolev/tmuxline.vim'

    " color scheme config
    let g:airline_theme='base16'
    let g:airline_powerline_fonts = 1

    let g:WebDevIconsOS = 'Darwin'
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:DevIconsEnableFoldersOpenClose = 1
    let g:DevIconsEnableFolderExtensionPatternMatching = 1

  " }}}

  " {{{ Other
    Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } " beautiful color previews
    Plug 'christoomey/vim-tmux-navigator'                     " work nicely with tmux C-h, C-j, C-k, C-l, C-\
    Plug 'liuchengxu/graphviz.vim'                            " graphviz support
  " }}}
call plug#end()

" must be called after plugin load
if exists('$BASE16_THEME')
    \ && (!exists('g:colors_name') 
    \ || g:colors_name != 'base16-$BASE16_THEME')
  let base16colorspace=256
  colorscheme base16-$BASE16_THEME
else
  colorscheme base16-github
" colorscheme base16-tokyo-city-terminal-dark
endif

" {{{ code completion (Part II)
set completeopt=menu,menuone,noselect

lua <<EOF

  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')
  require "lsp_signature".setup({
    handler_opts = {
      border = "none"   -- double, rounded, single, shadow, none
    }
  })
  
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end


  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) 
      end,
    },

    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
    },
    -- mapping = {
    --   ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    --   ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    --   ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    --   ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    --   ['<C-e>'] = cmp.mapping({
    --     i = cmp.mapping.abort(),
    --     c = cmp.mapping.close(),
    --   }),
    --   ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text', -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      })
    },
    completion = {
      autocomplete = false -- disable auto-completion
    }
  })
  
  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })
  
  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
  
  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  _G.vimrc = _G.vimrc or {}
  _G.vimrc.cmp = _G.vimrc.cmp or {}
  _G.vimrc.cmp.complete = function()
    cmp.complete()
  end

  --vim.cmd([[
  --  inoremap <C-x><C-o> <Cmd>lua vimrc.cmp.complete()<CR>
  --]])
  vim.cmd([[
    inoremap <C-space> <Cmd>lua vimrc.cmp.complete()<CR>
  ]])
  
  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['elmls'].setup {
  --   capabilities = capabilities
  -- }

  -- LSP setup
  local lspconfig = require'lspconfig'
  local util = require 'lspconfig/util'

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', 'gP', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gp', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>p', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>P', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- need to set workspace diagnostics, but how?
  -- vim.api.nvim_set_keymap('n', '<space>P', '<cmd>lua vim.diagnostic.setloclist({workspace = true})<CR>', opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- omnifunc should be disabled when used with nvim-cmp

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvv', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gvV', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '=', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>xa', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>xf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  -- requires the following language servers:
  -- npm i -g bash-language-server
  local servers = { 'elmls', 'gopls', 'terraformls', 'tsserver', 'jsonls', 'eslint', 'html', 'yamlls', 'bashls' }
  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
    }
  end

  -- setup gopls
  require('lspconfig').gopls.setup{
    on_attach = on_attach,
    cmd = {'gopls', 'serve'},
    capabilities = capabilities,
    filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
    root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
        gofumpt = true,
        env = {GOFLAGS="-tags=it"},
      },
    },
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    init_options = {
      usePlaceholders = true,
    }
  }

  -- the sqls language server is only setup if/when there is a DB_CONNECTION
  -- configured
  -- if os.getenv('DATABASE_URL') then
  --   require('lspconfig').sqls.setup{
  --     on_attach = function(client, bufnr)
  --       require('sqls').on_attach(client, bufnr)
  --       -- check whether this is not overriding some keybindings
  --       on_attach(client, bufnr)
  --     end,
  --     capabilities = capabilities,
  --     flags = {
  --       -- This will be the default in neovim 0.7+
  --       debounce_text_changes = 150,
  --     },
  --     settings = {
  --       sqls = {
  --         connections = {
  --           {
  --             driver = 'postgresql',
  --             dataSourceName = os.getenv('DATABASE_URL')
  --           },
  --         },
  --       },
  --     },
  --   }
  -- end


EOF
" TODO rework the key mappings for the nvim-lspconfig setup above - the current
" mappings are hardly usable and require tweaking

" }}}
