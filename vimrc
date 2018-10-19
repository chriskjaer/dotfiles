" --- General Settings ------------------------------------------------------ {
let mapleader = " "     " <SPACE> - The one true leader

" set autoindent          " Auto indent
" set autowrite           " Automatically :write before running commands
" set backspace=2         " Backspace deletes like most programs in insert mode
set colorcolumn=80      " Have a line of at 80 characters wide.
" set encoding=utf8       " Use utf8 as standard encoding
set ffs=unix,dos,mac    " Use Unix as the standard file type
set history=50
set hlsearch            " Highlight search results
set incsearch           " do incremental searching
set laststatus=2        " Always display the status line
set lazyredraw          " Don't redraw while executing macros (good performance config)
set magic               " For regular expressions turn magic on
" set mat=2               " How many tenths of a second to blink when matching brackets
set nobackup
set nocompatible        " Use Vim settings, rather then Vi settings
set noswapfile          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set showmatch           " Show matching brackets when text indicator is over them
" set ignorecase          " Ignore case when searching
set smartcase           " When searching try to be smart about cases
set so=10               " Keep current line a specified amount from bottom"
set nowrap              " Don't break up lines
" set cursorline          " Hightlights the line the cursor is at.
set synmaxcol=512
set number
set autoread
set undofile
set norelativenumber
" set noshowmode          " Don't show --- INSERT --- below the status line. This is handled by lightline

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

" --------------------------------------------------------------------------- }



" --- Plug Config ----------------------------------------------------------- {
"
" Install Plug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" --- Syntax & Visuals ---------------------------------
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-repeat'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'amperser/proselint', {'rtp': 'plugins/vim/syntastic_proselint/'}
Plug 'junegunn/rainbow_parentheses.vim' " Awesome for everything with parentheses!
Plug 'jparise/vim-graphql'

" Javascript
Plug 'moll/vim-node'
Plug 'pangloss/vim-javascript'

" --- Movement & UI -----------------------------------
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-unimpaired'

" Tmux
Plug 'christoomey/vim-tmux-navigator'

" --- Editing ----------------------------------------
Plug 'spf13/vim-autoclose'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'dyng/ctrlsf.vim'

" --- Misc --------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'jreybert/vimagit'
Plug 'w0rp/ale' " Async linting
Plug 'reasonml-editor/vim-reason-plus'
Plug 'slashmili/alchemist.vim'
Plug 'hashivim/vim-terraform'
" Plug 'airblade/vim-gitgutter'


" --- Autocompletion ----------------------------------
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'roxma/nvim-completion-manager'
" Plug 'roxma/nvim-cm-tern', {'do': 'yarn install'}
Plug 'Shougo/echodoc.vim'
Plug 'junegunn/fzf'

call plug#end()
filetype indent on
" --------------------------------------------------------------------------- }

" disable EX mode for now. Enable when I've grown a neckbeard...
nnoremap Q <nop>

" use pangloss-javascript
let g:polyglotldisabled = ['javascript']

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

  " Term
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l

  " Substitution preview
  set inccommand=nosplit
endif

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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

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

let g:ctrlp_working_path_mode = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore translations --ignore __fixtures__'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  let g:ag_prg='ag -S --nocolor --nogroup --column --ignore translations --ignore __fixtures__'
endif


nmap     <leader>s: <Plug>CtrlSFPrompt
vmap     <leader>sv <Plug>CtrlSFVwordExec
nmap     <leader>sw <Plug>CtrlSFCCwordExec
nmap     <leader>s/ <Plug>CtrlSFPwordExec
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>
inoremap <leader>st <Esc>:CtrlSFToggle<CR>

" Rainbow Stuff
au VimEnter * RainbowParentheses

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

" NeoSnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory='~/.snippets'

" --------------------------------------------------------------------------- }


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


" Colorscheme
" ===========
let g:hybrid_use_Xresources = 1
let base16colorspace=256
set background=dark
colorscheme base16-eighties
" set background=light
" colorscheme base16-solarized-light

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
autocmd FileType javascript nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^
autocmd FileType elixir nmap <Leader>cl yiwoIO.inspect(<c-r>", label: "<c-r>"")<Esc>^

" NVIM Completion Manager
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Ale
nmap <silent> <leader> ek <Plug>(ale_previous_wrap)
nmap <silent> <leader> ej <Plug>(ale_next_wrap)

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'elixir': ['credo'],
\   'terraform': ['tflint'],
\}

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'graphql': ['prettier'],
\   'css': ['prettier'],
\   'elixir': ['mix_format'],
\   'sh': ['shfmt'],
\}
let g:ale_javascript_prettier_options = '--single-quote --semi=false --trailing-comma es5'
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1


" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" ReasonML
set hidden
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }

" Automatically start language servers.
" let g:LanguageClient_autoStart = 1

" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
" nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<cr>
" nnoremap <silent> <cr> :call LanguageClient_textDocument_hover()<cr>
"
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:terraform_fmt_on_save=1
