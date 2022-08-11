
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
nnoremap <tab> za

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

"""relax map
nnoremap j gj
nnoremap k gk
inoremap jk <ESC>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap ; :

"" >_<
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
if system('uname -r') =~ "Microsoft"
    augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
    augroup END
endif
"" clip.exe for wsl2
" if system('uname -r') =~ "microsoft"
"     augroup Yank
"     autocmd!
"     autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
"     augroup END
" endif

" Compile function
noremap <leader>r :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		set splitbelow
		:sp
		:res -5
		term gcc % -o %< && time ./%<
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'cs'
		set splitbelow
		silent! exec "!mcs %"
		:sp
		:res -5
		:term mono %<.exe
	elseif &filetype == 'java'
		set splitbelow
		:sp
		:res -5
		term javac % && time java %<
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'racket'
		set splitbelow
		:sp
		:res -5
		term racket %
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc


" Plug
call plug#begin('~/.config/nvim/plugged')

    " git
    Plug 'airblade/vim-gitgutter'
    nmap <leader>g :GitGutterToggle<CR>
    Plug 'tpope/vim-fugitive'

    " Tagbar 
    Plug 'majutsushi/tagbar'
    map <leader>t :TagbarToggle<CR>

    " " NERDTree (replace by coc-explorer
    " Plug 'scrooloose/nerdtree'
    " map <leader>f :NERDTreeToggle<CR>
    " let NERDTreeShowHidden=1
    
    " fzf
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " markdown
    Plug 'godlygeek/tabular' 
    Plug 'plasticboy/vim-markdown'
    let g:tagbar_type_markdown = {'ctagstype' : 'markdown', 'kinds' : ['h:headings',],'sort' : 0}
    let g:vim_markdown_list_item_indent = 2
    let g:vim_markdown_math = 1
    Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'}
    let g:mkdp_browser = 'chrome.exe'
    nmap <leader>mv :MarkdownPreview<CR>
    nmap <leader>mx :StopMarkdownPreview<CR>
    Plug 'ferrine/md-img-paste.vim'
    autocmd FileType markdown nmap <buffer><silent> <leader>mp :call mdip#MarkdownClipboardImage()<CR>

    " conquer of completion
   Plug 'neoclide/coc.nvim', {'branch': 'release'}

   let g:coc_global_extensions = [
        \'coc-marketplace',
        \'coc-prettier',
        \'coc-explorer',
        \'coc-snippets',
        \'coc-json', 
        \'coc-markdownlint',
        \'coc-texlab',
        \'coc-vimlsp',
        \'coc-tsserver',
        \'coc-python',
        \'coc-pyright',
        \'coc-clangd',
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

   " Use `<Leader>-` and `<Leader>=` to navigate diagnostics
   " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
   nmap <silent> <leader>- <Plug>(coc-diagnostic-prev)
   nmap <silent> <Leader>= <Plug>(coc-diagnostic-next)

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
       call feedkeys('/<Leader>d', 'in')
     endif
   endfunction

  " Highlight the symbol and its references when holding the cursor.
   autocmd CursorHold * silent call CocActionAsync('highlight')

   " Symbol renaming.
   " nmap <leader>rn <Plug>(coc-rename)
       
   " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
     autocmd!
     " Setup formatexpr specified filetype(s).
     autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
     " Update signature help on jump placeholder.
     autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup en

    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " coc-explorer: open explorer by <leader>e
    nnoremap <leader>e :CocCommand explorer<CR>

    " coc-snippets
    " Use <C-l> for trigger snippet expand.
    imap <C-l> <Plug>(coc-snippets-expand)
    " Use <C-j> for select text for visual placeholder of snippet.
    vmap <C-j> <Plug>(coc-snippets-select)
    " Use <C-j> for jump to next placeholder, it's default of coc.nvim
    let g:coc_snippet_next = '<c-j>'
    " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
    let g:coc_snippet_prev = '<c-k>'
    " Use <C-j> for both expand and jump (make expand higher priority.)
    " equal to <tab> in vscode
    imap <C-j> <Plug>(coc-snippets-expand-jump)


    " snippets
    Plug 'honza/vim-snippets'
    let g:UltiSnipsSnippetDirectories=["UltiSnips","my_snippets"]

    " chinese
    " Plug 'Leiyi548/vim-im-select'

    " translater
    " Plug 'ianva/vim-youdao-translater'
    " vnoremap <silent> <leader>yy :<C-u>Ydv<CR>
    " nnoremap <silent> <leader>yy :<C-u>Ydc<CR>
    " noremap <leader>yi :<C-u>Yde<CR>
    
    " themes
    Plug 'vim-airline/vim-airline'
    Plug 'tomasiser/vim-code-dark'
    let g:airline_theme = 'codedark'
    
call plug#end()

colorscheme codedark

