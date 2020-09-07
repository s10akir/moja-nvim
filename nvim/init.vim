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


" ----- dein.vim/ ------
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein#install_process_timeout = 600

if &runtimepath !~# '/dein.vim'
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
" ----- /dein.vim ------


" ----- colorscheme/ -----
" MEMO: カラースキームはtomlではうまくロードできない
set background=light
colorscheme palenight
let g:airline_theme = "palenight"
" ----- /colorscheme -----
