" ----- visual/ -----
set number
set noerrorbells
set showmatch matchtime=1
set cinoptions+=:0
set cmdheight=2
set showcmd
set display=lastline
set list
set showmatch
set cursorline
set autoread
execute "set colorcolumn=" . join(range(121, 9999), ',')
" ----- /visual -----


" ----- search/ -----
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch
" ----- /search -----


" ----- edit/ -----
inoremap jj <Esc>
noremap <Esc><Esc> :noh<CR>
noremap ; :
set clipboard+=unnamedplus
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smartindent
" ----- /edit -----


" ----- control/ ----
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" ----- /control ----


" ----- other/ -----
set ttimeoutlen=10
" ----- /other -----


" ----- colorscheme/ -----
" MEMO: カラースキームはtomlではうまくロードできない
set termguicolors " 有効にするとSeiyaで透過できなくなる
let g:airline_theme = "bubblegum"
colorscheme panda
" ----- /colorscheme -----


" ----- plugins/ -----
runtime! plugins/*.vim
" ----- /plugins -----
