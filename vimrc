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
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c  " don't give |ins-completion-menu| messages.
set signcolumn=yes

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
" Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-repeat'
Plug 'junegunn/rainbow_parentheses.vim' " Awesome for everything with parentheses!
Plug 'pantharshit00/vim-prisma'
Plug 'joshdick/onedark.vim'
Plug 'bouk/vim-markdown'
Plug 'ap/vim-css-color'

" Javascript
Plug 'moll/vim-node'
Plug 'pangloss/vim-javascript'

" --- Movement & UI -----------------------------------
Plug 'ctrlpvim/ctrlp.vim'
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
" Plug 'w0rp/ale' " Async linting
" Plug 'hashivim/vim-terraform'
Plug 'tpope/vim-vinegar'
Plug 'leafgarland/typescript-vim', {'for': ['typescript', 'typescript.tsx']}
Plug 'peitalin/vim-jsx-typescript'
Plug 'tpope/vim-rails'
Plug 'junegunn/goyo.vim'


" --- Autocompletion ----------------------------------
" Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'roxma/nvim-completion-manager'
" Plug 'roxma/nvim-cm-tern', {'do': 'yarn install'}
Plug 'junegunn/fzf'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
filetype indent on
" --------------------------------------------------------------------------- }

" disable EX mode for now. Enable when I've grown a neckbeard...
nnoremap Q <nop>

" use pangloss-javascript
let g:polyglotldisabled = ['javascript']

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
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
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
" autocmd FileType markdown setlocal spell
" autocmd FileType markdown setlocal textwidth=80
" autocmd FileType markdown setlocal formatoptions+=a
let g:markdown_folding = 0
set nofoldenable


" CtrlP
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


" CtrlS
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


" --------------------------------------------------------------------------- }


" Display Settings
" ================
syntax on
syntax enable
" set t_Co=256

" Disable Background Color Erase (tmux)
" ====================================
" if &term =~ '256color'
"   set t_ut=
" endif


" Colorscheme
" ===========
" let g:hybrid_use_Xresources = 1
" let base16colorspace=256
" set background=dark

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

" set background=light
" colorscheme base16-solarized-light

" Add the current var at cursor to a console.log below the line
autocmd FileType javascript nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^
autocmd FileType typescript nmap <Leader>cl yiwoconsole.log('<c-r>"', <c-r>")<Esc>^
autocmd FileType elixir nmap <Leader>cl yiwoIO.inspect(<c-r>", label: "<c-r>"")<Esc>^

" " Ale
" nnoremap <leader>an :ALENextWrap<cr>
" nnoremap <leader>ap :ALEPreviousWrap<cr>
" nnoremap <leader>ad :ALEGoToDefinition<cr>
" nnoremap <leader>ah :ALEHover<cr>
" nnoremap <leader>ai :ALEDetail<cr>
"
"
" let g:ale_linters = {
" \   'elixir': ['credo'],
" \   'terraform': ['tflint'],
" \   'sh': ['shellcheck'],
" \   'dockerfile': ['hadolint'],
" \}
"
" let g:ale_javascript_eslint_use_global = 1
" let g:ale_javascript_eslint_executable = 'eslint_d'
"
" let g:ale_fixers = {
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \   'javascript': ['eslint'],
" \   'typescript': ['eslint'],
" \   'typescript.tsx': ['eslint'],
" \   'graphql': ['prettier'],
" \   'css': ['prettier'],
" \   'elixir': ['mix_format'],
" \   'sh': ['shfmt'],
" \   'python': ['black'],
" \}
" " let g:ale_javascript_prettier_options = '--single-quote --semi=false --trailing-comma es5'
" let g:ale_fix_on_save = 1
" let g:ale_completion_enabled = 1
" let g:ale_set_balloons = 1


let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'component_function': {
      \     'cocstatus': 'coc#status'
      \   },
      \ }

" let g:lightline.component_expand = {
"       \  'linter_checking': 'lightline#ale#checking',
"       \  'linter_warnings': 'lightline#ale#warnings',
"       \  'linter_errors': 'lightline#ale#errors',
"       \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \ }

let g:lightline.active = {
      \     'right':  [ [ 'linter_checking', 'linter_errors', 'linter_warnings' ] ],
      \     'left':   [ [ 'mode', 'paste' ],
      \                 [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ],
      \                 [ 'coc_status'  ],
      \                 [ 'readonly', 'filename', 'modified' ] ]
      \     }

call lightline#coc#register()

" -------- Coc ---------------------"


" Navigate snippet placeholders using tab
" let g:coc_snippet_next = '<Tab>'
" let g:coc_snippet_prev = '<S-Tab>'

" list of the extensions to make sure are always installed
let g:coc_global_extensions = [
            \'coc-css',
            \'coc-eslint',
            \'coc-html',
            \'coc-json',
            \'coc-marketplace',
            \'coc-prettier',
            \'coc-prisma',
            \'coc-syntax',
            \'coc-tsserver',
            \'coc-yaml',
            \'coc-cssmodules',
            \'coc-solargraph',
            \'coc-tailwind-intellisense',
            \]

if filereadable('./graphqlrc')
  let g:coc_global_extensions += ['coc-graphql']
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" For codeaction
nmap <leader>do <Plug>(coc-codeaction)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format  :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold    :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR      :call CocAction('runCommand', 'editor.action.organizeImport')


" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


" Zettelkasten
function! SNote(...)
  let path = strftime("%Y%m%d%H%M")." ".trim(join(a:000)).".md"
  execute ":sp " . fnameescape(path)
endfunction
command! -nargs=* SNote call SNote(<f-args>)

function! Note(...)
  let path = strftime("%Y%m%d%H%M")." ".trim(join(a:000)).".md"
  execute ":e " . fnameescape(path)
endfunction
command! -nargs=* Note call Note(<f-args>)

function! ZettelkastenSetup()
  if expand("%:t") !~ '^[0-9]\+'
    return
  endif
  " syn region mkdFootnotes matchgroup=mkdDelimiter start="\[\["    end="\]\]"

  inoremap <expr> <plug>(fzf-complete-path-custom) fzf#vim#complete#path("rg --files -t md \| sed 's/^/[[/g' \| sed 's/$/]]/'")
  imap <buffer> [[ <plug>(fzf-complete-path-custom)

  function! s:CompleteTagsReducer(lines)
    if len(a:lines) == 1
      return "#" . a:lines[0]
    else
      return split(a:lines[1], '\t ')[1]
    end
  endfunction

  inoremap <expr> <plug>(fzf-complete-tags) fzf#vim#complete(fzf#wrap({
        \ 'source': 'bash -lc "zk-tags-raw"',
        \ 'options': '--multi --ansi --nth 2 --print-query --exact --header "Enter without a selection creates new tag"',
        \ 'reducer': function('<sid>CompleteTagsReducer')
        \ }))
  imap <buffer> # <plug>(fzf-complete-tags)
endfunction

" Don't know why I can't get FZF to return {2}
function! InsertSecondColumn(line)
  " execute 'read !echo ' .. split(a:e[0], '\t')[1]
  exe 'normal! o' .. split(a:line, '\t')[1]
endfunction

command! ZKR call fzf#run(fzf#wrap({
        \ 'source': 'ruby ~/.bin/zk-related.rb "' .. bufname("%") .. '"',
        \ 'options': '--ansi --exact --nth 2',
        \ 'sink':    function("InsertSecondColumn")
      \}))

autocmd BufNew,BufNewFile,BufRead ~/Documents/Zettelkasten/*.md call ZettelkastenSetup()

map \d :put =strftime(\"%Y-%m-%d\")<CR>
