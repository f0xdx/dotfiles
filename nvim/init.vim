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

" {{{ platform config
  if (has('nvim'))
    " show results of substition as they're happening
    " but don't open a split
    set inccommand=nosplit
  endif
  if has('mouse')
    set mouse=a
  endif

  " TODO fix the cursor mess on windows terminal
  " switch cursor to line when in insert mode, and block when not
  " set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    " \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
    " \,sm:block-blinkwait175-blinkoff150-blinkon175

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

    set textwidth=79
    set colorcolumn=80
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
    " set shell=$SHELL

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
    set list
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
  " }}}

  " {{{ dev goodies (surround, repeat, commentary etc.)
    Plug 'junegunn/vim-easy-align' " align text visually
    Plug 'tpope/vim-repeat'        " repeat plugin actions with .
    Plug 'tpope/vim-commentary'    " easy commenting motions
    Plug 'tpope/vim-ragtag'        " endings for html, xml, etc. - ehances surround
    Plug 'tpope/vim-surround'      " surround motions with ( etc.
    Plug 'tpope/vim-endwise'       " add end, endif, etc. automatically
    Plug 'jiangmiao/auto-pairs'    " never forget a closing parenthesis

    let g:AutoPairsMapSpace=0
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
  " }}}

  " {{{ git (fugitive)
    Plug 'tpope/vim-fugitive'      " git support, alternative: https://github.com/jreybert/vimagit
    Plug 'airblade/vim-gitgutter'  " show status in gutter, alternative: vim-signify
  " }}}

  " {{{ easy access (nerdtree, startify, etc.)
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    Plug 'Xuyuanp/nerdtree-git-plugin' " git on a nerdtree
    Plug 'mhinz/vim-startify'          " add a nice startup screen for fast navigation

    " nerdtree config
    augroup nerdtree
      autocmd!
      autocmd FileType nerdtree setlocal nolist       " turn off whitespace characters
      autocmd FileType nerdtree setlocal nocursorline " turn off line highlighting for performance
    augroup END

    let NERDTreeShowHidden=1
    nmap <silent> <A-1> :NERDTreeToggle<cr>

    " startify config
    let g:startify_files_number = 5
    let g:startify_change_to_dir = 0
    let g:startify_relative_path = 1
    let g:startify_use_env = 1
    let g:startify_session_dir = expand(stdpath('data') . '/sessions/')
    let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]

    let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]

    let g:startify_bookmarks = [
        \ { 'c': expand($MYVIMRC)},
        \ { 'g': '~/.gitconfig' },
        \ ]
        " \ { 'c': '~/.config/nvim/init.vim' },

    autocmd User Startified setlocal cursorline
  " }}}

  " {{{ markdown support
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
  " }}}
  
  " {{{ fzf + rgrep
    Plug 'junegunn/fzf', { 'dir': expand(stdpath('config') . '/fzf/'), 'do': './install --bin' }
    " Plug 'C:\ProgramData\chocolatey\bin\fzf.exe'
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
  " }}}
  
  " TODO improve fzf configuration similarly to https://github.com/nicknisi/dotfiles/blob/master/config/nvim/init.vim
  " TODO integrate bat preview into fzf results
  " TODO check whether to replace gitgutter w/ https://github.com/mhinz/vim-signify
  " TODO neomake vs ALE for linting https://github.com/neomake/neomake
  " TODO check whether to use multiple cursors: Plug 'terryma/vim-multiple-cursors'
  " TODO check indent guides: Plug 'nathanaelkane/vim-indent-guides'
  " TODO check inspiration at
  "  * https://github.com/zenbro/dotfiles/blob/master/.nvimrc
  "  * https://github.com/nicknisi/dotfiles/blob/master/config/nvim/init.vim
  
  " TODO some suggestions on how to provide: https://jacky.wtf/weblog/language-client-and-neovim/
  " TODO rust based lsp client: https://github.com/autozimu/LanguageClient-neovim
  " TODO asynchronous completion in neovim: https://github.com/ncm2/ncm2
  " {{{ code completion
  " TODO complete code completion
  " }}}
  "
  " {{{ keybindings
    let mapleader="\<space>"
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
    nnoremap <silent> <leader>" :vnew +terminal<Cr>
    " nnoremap <silent> <leader>' :new +terminal<Cr>
    " nnoremap <silent> <leader>' :new +terminal <Bar> exe "resize " . (winheight(0) * 2/3)<CR>
    nnoremap <silent> <leader>' :exe (winheight(0) * 1/3). "new +terminal"<CR>
  "}}}
  
  " {{{ appearance (onedark, airline, devicons)
    Plug 'joshdick/onedark.vim'    " onedark, what else?
    Plug 'vim-airline/vim-airline' " airline for overview
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'  " add icons to different filetypes

    " color scheme config
    let g:airline_theme='onedark'
    let g:onedark_hide_endofbuffer=1
    let g:onedark_terminal_italics=1
    let g:airline_powerline_fonts = 1

    let g:WebDevIconsOS = 'Linux'
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:DevIconsEnableFoldersOpenClose = 1
    let g:DevIconsEnableFolderExtensionPatternMatching = 1

  " }}}
call plug#end()

" must be called after plugin load
colorscheme onedark
