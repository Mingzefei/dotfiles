"This dotfile is for Ubuntu-20.04 nvim in WS2.
" Create from vimrc in WSL2 Ubuntu-20.04

"""basic setting
let mapleader=" "
set nocompatible " for some old bugs
set encoding=utf-8
set updatetime=100
set mouse=a
set autochdir " auto mv to current file's dir
set hidden " change buffer with file unsave
filetype on
set vb t_vb= " no error bell
syntax on " syntax highlight

"""auto go to last edit
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"""show setting
set number
set relativenumber
set cursorline " high light current line
set scrolloff=6 " 6 lines free for bottom and top
if &term =~ "xterm" " Set cursor shape and color
    " INSERT mode
    let &t_SI = "\<Esc>[6 q"
    " REPLACE mode
    let &t_SR = "\<Esc>[3 q"
    " NORMAL mode
    let &t_EI = "\<Esc>[2 q"
endif

"""tab, indent and fold
set smartindent " indent smartly when start a new line
set backspace=indent,eol,start " for delete bug
set tabstop=4 " tab equal to 4 space
set shiftwidth=4 " << >> equal to 4 space
set expandtab
set softtabstop=4 " del 4 space at one time
set foldmethod=indent
set foldlevelstart=99

"""search and highline
set wildmenu
set hlsearch
exec "nohlsearch"
set incsearch " show search results while input /char
set ignorecase
set smartcase
nnoremap /<CR> :nohlsearch<CR>
nnoremap n nzz
nnoremap N Nzz

""" minus or add number
""" <C-a> has been used by tmux
nnoremap - <C-x>
nnoremap + <C-a>

""" move in insert mode
" inoremap <C-h> <Left>
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
" inoremap <C-l> <Right>
" inoremap <C-l> <Right>

"""windows
nnoremap <C-w>x <C-w>c
nnoremap <C-w>- <C-w>s
nnoremap <C-w>= <C-w>v

""" term
nnoremap <C-w>t :tabe<CR>:term<CR>
tnoremap jk <C-\><C-n>


"""relax map
nnoremap j gj
nnoremap k gk
inoremap jk <ESC>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap ; :
vnoremap ; :

"snippets
map <leader><tab> <esc>/>_<<CR>:nohlsearch<CR>c3l
source ~/.config/nvim/my_snippets/my_vim_snippets
" source ~/.vim/my_snippets/my_vim_snippets

"" fy word (need fanyi)
nmap <Leader>yy :!fanyi <C-R><C-W><CR>
" fanyi input word(s)
nmap <Leader>yi :!fanyi

"" spell check
nnoremap <leader>s :set spell!<CR>

"" clip.exe for wsl1
" if system('uname -r') =~ "Microsoft"
"     augroup Yank
"     autocmd!
"     autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
"     augroup END
" endif
"" clip.exe for wsl2
if system('uname -r') =~ "microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
    augroup END
endif


" Plug
call plug#begin('~/.config/nvim/plugged')

" chatgpt
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'jackMort/ChatGPT.nvim'


" github copilot
Plug 'github/copilot.vim'
let g:copilot_proxy = expand('$hostip').':7890'

" git and lazygit
Plug 'airblade/vim-gitgutter'
nnoremap ]g               : GitGutterNextHunk<CR>
nnoremap [g               : GitGutterPrevHunk<CR>
nnoremap <leader>gp       : GitGutterPreviewHunk<CR>
nnoremap <leader>gs       : GitGutterStageHunk<CR>
nnoremap <leader>gu       : GitGutterUndoHunk<CR>
Plug 'tpope/vim-fugitive'
noremap \g :Git<CR>
noremap <c-g> :tabe<CR>:-tabmove<CR>:term lazygit<CR>

" Goyo and limelight
Plug 'junegunn/goyo.vim'
nmap <leader>gy           : Goyo<CR>
xmap <leader>gy           : Goyo<CR>

" Tagbar
Plug 'majutsushi/tagbar'
map <leader>t             : TagbarToggle<CR>

" easy motion
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_smartcase = 1
nnoremap f <Plug>(easymotion-s)

" snippets
Plug 'honza/vim-snippets'
let g:UltiSnipsSnippetDirectories=["UltiSnips","my_snippets"]

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" tabular
Plug 'godlygeek/tabular'
" usage :Tabularize /regex/ or :Tabularize /regex/ {options}

" autoformat
let g:python3_host_prog="/usr/bin/python3"
Plug 'vim-autoformat/vim-autoformat'
" usage :Autoformat
" autocmd BufWritePre * :Autoformat

" markdown
" Plug 'plasticboy/vim-markdown'
" let g:tagbar_type_markdown          = {'ctagstype' : 'markdown', 'kinds' : ['h:headings',],'sort' : 0}
" let g:vim_markdown_list_item_indent = 2
" let g:vim_markdown_math             = 1
"" table
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
"" usage :TableModeToggle
"" preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'}
let g:mkdp_browser = 'chrome.exe'
nmap <leader>mv :MarkdownPreview<CR>
nmap <leader>mx :StopMarkdownPreview<CR>

" ipynb
" autocmd BufNewFile,BufRead *.ipynb Plug 'luk400/vim-jukit'
" Plug 'luk400/vim-jukit'
" let g:jukit_mappings_ext_enabled = ['ipynb'] " enable the mappings only in .ipynb files
" let g:jukit_notebook_viewer = 'code' " command to open .ipynb files, by default jupyter-notebook is used.

" conquer of completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = [
            \'coc-marketplace',
            \'coc-highlight',
            \'coc-prettier',
            \'coc-flutter',
            \'coc-translator',
            \'coc-explorer',
            \'coc-snippets',
            \'coc-json',
            \'coc-markdownlint',
            \'coc-texlab',
            \'coc-vimlsp',
            \'coc-tsserver',
            \'coc-python',
            \'coc-pyright',
            \'coc-todolist',
            \'coc-todo-tree',
            \'coc-cmake',]

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

" Use <C-j> and <C-k> to navigate the completion list
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" Use <C-o> to trigger completion.
inoremap <silent><expr> <C-o> coc#refresh()

"" snippets
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <Leader>d to show documentation in preview window.
nnoremap <silent> <leader>d :call ShowDocumentation()<CR>

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

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
"Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" coc-explorer: open explorer by <leader>e
nnoremap <leader>e :CocCommand explorer<CR>

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" vim start up time
Plug 'dstein64/vim-startuptime'

" chinese
" Plug 'Leiyi548/vim-im-select'

" themes
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
let g:airline_theme = 'codedark'

call plug#end()

lua <<EOF
-- chat gpt
require("chatgpt").setup()
EOF

colorscheme codedark

