" Thanks to thoughbot for their excellent .vimrc, which I've shamelessly
" copied: https://github.com/thoughtbot/dotfiles/blob/master/vimrc and mangled
" into my own.


" --- General Settings ------------------------------------------------------ {
let mapleader = " "     " <SPACE> - The one true leader

set autoindent          " Auto indent
set autowrite           " Automatically :write before running commands
set backspace=2         " Backspace deletes like most programs in insert mode
set cmdheight=1         " Command bar height
set colorcolumn=80      " Have a line of at 80 characters wide.
set encoding=utf8       " Use utf8 as standard encoding
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

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=3
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
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/vim-easy-align'
" Plug 'scrooloose/syntastic'
Plug 'benekastah/neomake'
Plug 'tpope/vim-repeat'

" Javascript
Plug 'moll/vim-node'

" Clojure
Plug 'junegunn/rainbow_parentheses.vim' " Awesome for everything with parentheses!


" --- Movement & UI -----------------------------------
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'

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

" --- Misc --------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'geekjuice/vim-spec'
Plug 'rking/ag.vim'
Plug 'junegunn/goyo.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'ervandew/supertab'
Plug 'jreybert/vimagit'


call plug#end()
filetype indent on
" --------------------------------------------------------------------------- }


" --- Elixir ---------------------------------------------------------------- {
autocmd FileType elixir call SetElixirOptions()
function! SetElixirOptions() abort
  nnoremap <leader>mt :! clear & mix test<cr>
endfunction
" --------------------------------------------------------------------------- }



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


  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  " Term
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif


" Neomake
let g:neomake_javascript_enabled_makers = ['standard']
let g:neomake_jsx_enabled_makers = ['standard']

autocmd! BufWritePost * Neomake

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
let NERDTreeChDirMode = 1
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


autocmd FileType text setlocal textwidth=78

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
  autocmd bufwritepost .vimrc source $MYVIMRC
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

" Ignore html in syntastic since it doesn't handle handlebars
let syntastic_mode_map = { 'passive_filetypes': ['html'] }


set timeout timeoutlen=1000 ttimeoutlen=10

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

" Auto reload vimrc when it's changed
" augroup myvimrc
"   au!
"   au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
" augroup END

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
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'

