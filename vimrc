" Thanks to thoughbot for their excellent .vimrc, which I've shamelessly
" copied: https://github.com/thoughtbot/dotfiles/blob/master/vimrc and added
" some of my own tweaks to.

" Leader
let mapleader = " "


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
set lbr                 " Linebreak
set magic               " For regular expressions turn magic on
set mat=2               " How many tenths of a second to blink when matching brackets
set nobackup
set nocompatible        " Use Vim settings, rather then Vi settings
set noswapfile          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set nowritebackup
set number              " Line numbers
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set showmatch           " Show matching brackets when text indicator is over them
set smartcase           " When searching try to be smart about cases
set so=10               " Keep current line a specified amount from bottom"
set nowrap
set cursorline
set synmaxcol=512
" set relativenumber      " Fun with relative numbers

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500"

" Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'


Plugin 'editorconfig/editorconfig-vim'

" Git
""""""""""""""""""""""""
Plugin 'tpope/vim-fugitive'


" Syntax fun an visual help "
"""""""""""""""""""""""""""""
" Color Schemes"
Plugin 'chriskempson/base16-vim'

" HEX Colors and other nice highlights
Plugin 'ap/vim-css-color'

" Less syntax support
Plugin 'groenewege/vim-less'

" Stylus syntax
Plugin 'wavded/vim-stylus.git'

" Sass / Haml Syntax
Plugin 'tpope/vim-haml'

" Markdown syntax for vim
Plugin 'tpope/vim-markdown'

" Shows indent level
Plugin 'nathanaelkane/vim-indent-guides'

" Jade syntax
Plugin 'digitaltoad/vim-jade'

" A Vim plugin which shows a git diff in the gutter (sign column)
Plugin 'airblade/vim-gitgutter'

" Lean powerline implmentation "
Plugin 'bling/vim-airline'

" Handlebars / Mustache syntax
Plugin 'mustache/vim-mustache-handlebars'

Plugin 'tpope/vim-repeat.git'
Plugin 'junegunn/vim-easy-align'

" C#
Plugin 'OrangeT/vim-csharp'

" PHP
Plugin 'StanAngeloff/php.vim'


" Movement "
""""""""""""
" File tree implementation "
Plugin 'scrooloose/nerdtree'

" Sublime-like Command-P"
Plugin 'kien/ctrlp.vim'

" Replaces CtrlP and many other plugins,
" see http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/
Plugin 'Shougo/vimproc.vim' " Dependency for unite
Plugin 'Shougo/unite.vim'

" Typing "
""""""""""
" Awesome autocomple"
Plugin 'Valloric/YouCompleteMe'

" Complete parenteses, brackets etc."
Plugin 'spf13/vim-autoclose'

Plugin 'mattn/emmet-vim'

" Sorround stuff easier"
Plugin 'tpope/vim-surround'

" Allround linter "
Plugin 'scrooloose/syntastic'

" Comment/Uncomment "
Plugin 'tomtom/tcomment_vim'


" Clojure "
"""""""""""
Plugin 'tpope/vim-fireplace'
" Plugin 'guns/vim-clojure-static'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'guns/vim-clojure-highlight'

" Javascript
""""""""""""
Plugin 'maksimr/vim-jsbeautify'
Plugin 'einars/js-beautify'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'moll/vim-node'

" Tmux "
""""""""
Plugin 'edkolev/tmuxline.vim'
Plugin 'tpope/vim-obsession'

" See http://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits
Plugin 'christoomey/vim-tmux-navigator'

" Tests
"""""""
Plugin 'geekjuice/vim-spec'

call vundle#end()            " required
filetype plugin indent on    " required

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Fonts & Typography
set guifont=Menlo:h14
set linespace=4

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Format the status line
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Fast saving
nmap <leader>w :w!<cr>

" Clojure
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" NerdTree
nmap <leader>n :NERDTree<cr>
let NERDTreeChDirMode = 1
let NERDTreeWinSize=25
" let NERDTreeQuitOnOpen=1

" Explorer
nmap <leader>e :Explore<cr>

" Color scheme
set background=dark
colorscheme base16-default

" Airline Fonts
let g:airline_powerline_fonts = 1

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


" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv"

" Escape insert mode the easy way
inoremap jj <Esc>
cnoremap jj <Esc>

" Unite
let g:unite_source_history_yank_enable = 1
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup -S -C4'
nnoremap <leader>y :Unite history/yank<cr>

nnoremap <leader>/ :Unite grep:.<cr>

" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
    set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" ruby path if you are using rbenv
let g:ruby_path = system('echo $HOME/.rbenv/shims')

" clear search highlight on hitting esc
nnoremap <esc> :noh<return><esc>

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Ignore html in syntastic since it doesn't handle handlebars
let syntastic_mode_map = { 'passive_filetypes': ['html'] }

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

set timeout timeoutlen=1000 ttimeoutlen=100

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

" Copy current buffer path relative to root of VIM session to system clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>

" Copy current filename to system clipboard
nnoremap <Leader>yf :let @*=expand("%:t")<cr>:echo "Copied file name to clipboard"<cr>

" Copy current buffer path without filename to system clipboard
nnoremap <Leader>yd :let @*=expand("%:h")<cr>:echo "Copied file directory to clipboard"<cr>
