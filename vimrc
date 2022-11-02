" --- General Settings ------------------------------------------------------ {
let mapleader = ","

set colorcolumn=80      " Have a line of at 80 characters wide.
set ffs=unix,dos,mac    " Use Unix as the standard file type
set history=50
set hlsearch            " Highlight search results
set incsearch           " do incremental searching
set laststatus=2        " Always display the status line
set lazyredraw          " Don't redraw while executing macros (good performance config)
set magic               " For regular expressions turn magic on
set noswapfile          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set showmatch           " Show matching brackets when text indicator is over them
set ignorecase          " Ignore case when searching
set smartcase           " When searching try to be smart about cases
set so=10               " Keep current line a specified amount from bottom"
set nowrap              " Don't break up lines
set synmaxcol=512
set number
set autoread
set undofile
set norelativenumber
set number

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


" required by coc
set nobackup
set nowritebackup
" set cmdheight=1
set updatetime=300
set signcolumn=yes
" set shortmess+=c  " don't give |ins-completion-menu| messages.

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
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-repeat'
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-abolish'

" --- Movement & UI -----------------------------------
Plug 'tpope/vim-unimpaired'

" Tmux
Plug 'christoomey/vim-tmux-navigator'

" --- Editing ----------------------------------------
Plug 'spf13/vim-autoclose'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'dyng/ctrlsf.vim'

" --- Misc --------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/goyo.vim'


call plug#end()
filetype indent on
" --------------------------------------------------------------------------- }

lua <<EOF
-- load lua config
require("config")
EOF

" disable EX mode for now. Enable when I've grown a neckbeard...
nnoremap Q <nop>

" use pangloss-javascript
" let g:polyglotldisabled = ['javascript']

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

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("termguicolors"))
  set termguicolors
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

" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'

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
autocmd FileType markdown setlocal spell
let g:markdown_folding = 0
set nofoldenable


" CtrlS
nmap     <leader>s: <Plug>CtrlSFPrompt
vmap     <leader>sv <Plug>CtrlSFVwordExec
nmap     <leader>sw <Plug>CtrlSFCCwordExec
nmap     <leader>s/ <Plug>CtrlSFPwordExec
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>
inoremap <leader>st <Esc>:CtrlSFToggle<CR>

" Rainbow Stuff
" au VimEnter * RainbowParentheses

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


" --------------------------------------------------------------------------- }


" Display Settings
" ================
syntax on
syntax enable

" Colorscheme
" ===========
let g:hybrid_use_Xresources = 1
let base16colorspace=256

let env = environ()
if (env['DARK_MODE'] == 1) 
  set background=dark
else
  set background=light
endif

if (&background == 'dark')
  colorscheme onedark

  highlight Normal                        guibg=#21242a
  highlight MatchParen    guifg=#C678DD   guibg=#504066
  highlight LineNr        guifg=#151822
  highlight CursorLineNr  guifg=#56B6C2
  highlight Error         guifg=#f57373   guibg=#804040
  highlight vimError      guifg=#f57373   guibg=#804040

  hi IndentGuidesEven     guifg=#1f1f28   guibg=#21242a
  hi IndentGuidesOdd      guifg=#1f1f28   guibg=#262a36
  hi Comment              guifg=#4a5158                   cterm=italic
  hi String               guifg=#98C379   guibg=#2a2e34

  """ browns
  " function params: numbers and constants
  hi Statement            guifg=#907161
  hi Conditional          guifg=#907161
  hi Keyword              guifg=#56B6C2
  hi Function             guifg=#56B6C2

  " Yellows
  hi Number               guifg=#E5C07B
  hi Special              guifg=#E5C07B
  hi Boolean              guifg=#E5C07B

  " purple
  hi CtrlPMatch           guifg=#ba9ef7
  hi Visual               guibg=#364652

  " medium red: if else operators
  hi Preproc              guifg=#e86868
  hi Type                 guifg=#e86868



  """""" vim-jsx ONLY
  hi Identifier           cterm=italic

  " Blues
  " light blues
  hi xmlTagName           guifg=#59ACE5
  hi xmlTag               guifg=#59ACE5

  " dark blues
  hi xmlEndTag            guifg=#2974a1
  hi jsxCloseString       guifg=#2974a1
  hi htmlTag              guifg=#2974a1
  hi htmlEndTag           guifg=#2974a1
  hi htmlTagName          guifg=#59ACE5
  hi jsxAttrib            guifg=#1BD1C1

  " cyan
  hi Constant                           guifg=#56B6C2
  hi typescriptBraces                   guifg=#56B6C2
  hi typescriptEndColons                guifg=#56B6C2
  hi typescriptRef                      guifg=#56B6C2
  hi typescriptPropietaryMethods        guifg=#56B6C2
  hi typescriptEventListenerMethods     guifg=#56B6C2
  hi typescriptFunction                 guifg=#56B6C2
  hi typescriptVars                     guifg=#56B6C2
  hi typescriptParen                    guifg=#56B6C2
  hi typescriptDotNotation              guifg=#56B6C2
  hi typescriptBracket                  guifg=#56B6C2
  hi typescriptBlock                    guifg=#56B6C2
  hi typescriptJFunctions               guifg=#56B6C2
  hi typescriptSFunctions               guifg=#56B6C2
  hi typescriptInterpolationDelimiter   guifg=#56B6C2
  hi typescriptIdentifier               guifg=#907161   cterm=italic

  " javascript
  hi jsParens             guifg=#56B6C2
  hi jsObjectBraces       guifg=#C678DD
  hi jsFuncBraces         guifg=#56B6C2
  hi jsObjectFuncName     guifg=#D19A66
  hi jsObjectKey          guifg=#56B6C2

  let g:lightline = { 'colorscheme': 'onedark' }
else
  colorscheme base16-solarized-light
  let g:lightline = { 'colorscheme': '16color' }
endif

" Add the current var at cursor to a console.log below the line
autocmd FileType javascript nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^
autocmd FileType typescript nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^
