" Thanks to thoughbot for their excellent .vimrc, which I've shamelessly
" copied: https://github.com/thoughtbot/dotfiles/blob/master/vimrc and mangled
" into my own.


" --- General Settings ------------------------------------------------------ {
let mapleader = " "     " <SPACE> - The one true leader

set autoindent          " Auto indent
set autowrite           " Automatically :write before running commands
set backspace=2         " Backspace deletes like most programs in insert mode
set colorcolumn=80      " Have a line of at 80 characters wide.
" set encoding=utf8       " Use utf8 as standard encoding
set ffs=unix,dos,mac    " Use Unix as the standard file type
set history=50
set hlsearch            " Highlight search results
set ignorecase          " Ignore case when searching
set incsearch           " do incremental searching
set laststatus=2        " Always display the status line
set lazyredraw          " Don't redraw while executing macros (good performance config)
set magic               " For regular expressions turn magic on
set mat=2               " How many tenths of a second to blink when matching brackets
set nobackup
set nocompatible        " Use Vim settings, rather then Vi settings
set noswapfile          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set showmatch           " Show matching brackets when text indicator is over them
set smartcase           " When searching try to be smart about cases
set so=10               " Keep current line a specified amount from bottom"
set nowrap              " Don't break up lines
set cursorline          " Hightlights the line the cursor is at.
set synmaxcol=512
set number
set autoread
set undofile

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
" --------------------------------------------------------------------------- }



" --- Plug Config --------------------------------------------------------- {
call plug#begin('~/.vim/plugged')

" --- Syntax & Visuals ---------------------------------
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/vim-easy-align'
Plug 'benekastah/neomake'
Plug 'tpope/vim-repeat'
Plug 'ElmCast/elm-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'amperser/proselint', {'rtp': 'plugins/vim/syntastic_proselint/'}
Plug 'junegunn/rainbow_parentheses.vim' " Awesome for everything with parentheses!

" Javascript
Plug 'moll/vim-node'
Plug 'pangloss/vim-javascript'

" --- Movement & UI -----------------------------------
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-unimpaired'

" Tmux
Plug 'christoomey/vim-tmux-navigator' " See http://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits

" --- Editing ----------------------------------------
Plug 'spf13/vim-autoclose'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Olical/vim-enmasse'

" --- Misc --------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'junegunn/goyo.vim'
Plug 'ervandew/supertab'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fireplace'
Plug 'sbdchd/neoformat'
Plug 'jaawerth/neomake-local-eslint-first'
Plug 'wakatime/vim-wakatime'

call plug#end()
filetype indent on
" --------------------------------------------------------------------------- }

" disable EX mode for now. Enable when I've grown a neckbeard...
nnoremap Q <nop>

" --- Elixir ---------------------------------------------------------------- {
autocmd FileType elixir call SetElixirOptions()
function! SetElixirOptions() abort
  nnoremap <leader>mt :! clear & mix test<cr>
endfunction
" --------------------------------------------------------------------------- }

" use pangloss-javascript
let g:polyglot_disabled = ['javascript']

if (has("termguicolors"))
 set termguicolors
endif

" Neovim
" ======
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  " Hack to get C-h working in neovim
  nmap <BS> <C-W>h
  tnoremap <Esc> <C-\><C-n>

  " Deoplete
  " ========
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#omni_patterns = {}
  let g:deoplete#omni_patterns.elm = '\.'

  " Term
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Neoformat
" Use formatprg when available
let g:neoformat_try_formatprg = 1
autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --single-quote\ --semi=false\ --trailing-comma\ es5
autocmd BufWritePre *.js Neoformat

" Neomake
" let g:neomake_javascript_standard_args = ['--fix', '-w', '-v', '%:p']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']
autocmd! BufWritePost * Neomake

" Callback for reloading file in buffer when standard has finished and maybe has
" autofixed some stuff
" function! s:Neomake_callback(options)
"   if (a:options.name ==? 'standard') && (a:options.has_next == 0)
"     " reload the file when the job is done
"     checktime
"   endif
" endfunction

" Call neomake#Make directly instead of the Neomake provided command so we can
" inject the callback
" autocmd BufWritePost * call neomake#Make(1, [], function('s:Neomake_callback'))

" --- Keybindings ----------------------------------------------------------- {
"
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Fast saving
nmap <leader>w :w!<cr>

" NerdTree
nmap <leader>n :NERDTree<cr>
let NERDTreeChDirMode=1
let NERDTreeWinSize=28
" let NERDTreeQuitOnOpen=1

" Explorer
nmap <leader>e :Explore<cr>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv"

" Escape insert mode the easy way
inoremap jj <Esc>
cnoremap jj <Esc>
inoremap jk <Esc>
cnoremap jk <Esc>

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" clear search highlight on hitting esc
nnoremap <esc> :noh<return><esc>

" -------------------------------------------------------------------------- }


autocmd FileType text setlocal textwidth=80

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
 \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
 \   exe "normal g`\"" |
 \ endif


" Markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

" Enable spellchecking for Markdown
autocmd FileType markdown setlocal spell

" Automatically wrap at 80 characters for Markdown
autocmd BufRead,BufNewFile *.md setlocal textwidth=80


" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " Open a search prompt
  nnoremap <leader>s: :Ag!<space>

  " Search for visual selection, set as last search pattern
  vnoremap <leader>sv y:let @/ = @"<CR>:Ag! '<C-R>/'<CR>

  " Search for word under cursor, match word boundary, set as last search pattern
  nnoremap <leader>sw yiw:let @/ = @"<CR>:Ag! -w '<C-R>/'<CR>

  " Search after last search result
  nnoremap <leader>s/ :AgFromSearch!<CR>
endif



" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" configure syntastic syntax checking to check on open as well as save
" let g:syntastic_check_on_open=1
" jsx goodness, see https://github.com/scrooloose/syntastic/wiki/JavaScript:---jsxhint
" let g:syntastic_javascript_checkers = ['standard']
" JSX highlights in non jsx js files
let g:jsx_ext_required = 0

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost vimrc source $MYVIMRC
endif

" Rainbow Stuff
au VimEnter * RainbowParentheses

" Use a low updatetime. This is used by CursorHold
set updatetime=1000

" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a
" DCS
" sequence
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
    set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" set timeout timeoutlen=1000 ttimeoutlen=10

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" NeoSnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"

let g:neosnippet#snippets_directory='~/.snippets'

" --------------------------------------------------------------------------- }

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make setlocal noexpandtab
autocmd FileType json setlocal conceallevel=0


" Display Settings
" ================
syntax on
syntax enable
set t_Co=256

" Disable Background Color Erase (tmux)
" ====================================
if &term =~ '256color'
  set t_ut=
endif

" Completion
" ==========
set wildmode=longest,list,full
set wildmenu                    " Enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~     " Stuff to ignore when tab completing
set wildignore+=*vim/backups*

" Colorscheme
" ===========
let g:hybrid_use_Xresources = 1
set background=dark
let base16colorspace=256
colorscheme base16-eighties

" Airline
" =======
let g:airline_powerline_fonts = 0
let g:airline_theme = 'eighties'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Snippets
" ========

" Rename current file, thanks Gary Bernhardt via Ben Orenstein
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>mv :call RenameFile()<cr>

" Add the current var at cursor to a console.log below the line
nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^

" Elm
" ===
let g:polyglot_disabled = ['elm'] " Use elm.vim instead of polyglot

let g:elm_setup_keybindings = 0
au FileType elm nmap <leader>lm <Plug>(elm-make)
au FileType elm nmap <leader>lb <Plug>(elm-make-main)
au FileType elm nmap <leader>lt <Plug>(elm-test)
au FileType elm nmap <leader>lr <Plug>(elm-repl)
au FileType elm nmap <leader>le <Plug>(elm-error-detail)
au FileType elm nmap <leader>ld <Plug>(elm-show-docs)
au FileType elm nmap <leader>lh <Plug>(elm-browse-docs)
au FileType elm nmap <leader>lf <Plug>(elm-format)

au FileType elm set shiftwidth=2 softtabstop=2 tabstop=2
let g:elm_format_autosave = 1
