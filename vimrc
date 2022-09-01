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
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'josa42/vim-lightline-coc'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-repeat'
Plug 'junegunn/rainbow_parentheses.vim' " Awesome for everything with parentheses!
Plug 'pantharshit00/vim-prisma'
Plug 'joshdick/onedark.vim'
Plug 'bouk/vim-markdown'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-abolish'
Plug 'amadeus/vim-mjml'

" Javascript
Plug 'moll/vim-node'
Plug 'pangloss/vim-javascript'

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
Plug 'leafgarland/typescript-vim', {'for': ['typescript', 'typescript.tsx']}
Plug 'peitalin/vim-jsx-typescript'
Plug 'tpope/vim-rails'
Plug 'junegunn/goyo.vim'
Plug 'neovim/nvim-lspconfig'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 


" --- Autocompletion ----------------------------------
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

let g:lightline.component_function = {
      \   'cocstatus': 'coc#status'
      \ }

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
            \]

if filereadable('./graphqlrc')
  let g:coc_global_extensions += ['coc-graphql']
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')


" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}
EOF

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP
" lua << EOF
"   require'lspconfig'.graphql.setup{}
" EOF
