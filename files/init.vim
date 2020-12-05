" ================ Plugins ==================== {{{
"
call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf'
Plug 'christoomey/vim-tmux-runner'
Plug 'janko/vim-test'
Plug 'junegunn/fzf.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'keith/rspec.vim'
Plug 'ledger/vim-ledger'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'vimwiki/vimwiki'
call plug#end()
"
"}}}
"
" ================ General Config ==================== {{{
"
let g:mapleader = ','                                                           " Change leader to a comma

au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger

" set hidden                                                                      " Hide buffers in the background instead of closing them
set path+=**
"
" ================ Indentation ====================== {{{
"
set colorcolumn=120
set expandtab                                                                   " Convert tabs to spaces
set incsearch                                                                   " Searches incremetally as you type
set list                                                                        " Enable listchars
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮                 " Set trails for tabs and space
set nofoldenable                                                                " Disable folding by default
set nowrap                                                                      " Disable words wrap
set shiftround                                                                  " When shifting lines, round the indentation to the nearest multiple of 'shiftwidth'
set shiftwidth=2                                                                " When shifting, indent using four spaces
set smartindent
set softtabstop=2
set tabstop=2
"
" }}}
"
" ================ Colors ======================== {{{
"
colorscheme gruvbox                                                             " Theme
"
" }}}
"
" ================ Custom mappings ======================== {{{
"
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
"
" Clear search highlights
nnoremap <Leader>h :noh<CR>
"
"}}}
"
" ================ Plugins settings ======================== {{{
"
" [*] NerdTree
"
" Open NERDTree
nnoremap <Space><Space> :NERDTreeToggle<CR>
" Find current file in NERDTree
nnoremap <Leader>hf :NERDTreeFind<CR>
"
" [*] FZF
"
set rtp+=/usr/local/opt/fzf
" Toggle files list
nnoremap <C-p> :Files<CR>
" Toggle buffer list
nnoremap <C-x> :Buffers<CR>
"
" [*] Grepper
"
" Toggle Grepper
nnoremap <Leader>a :Grepper -tool ag<CR>
"
" [*] vim-wiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]"
"
" [*] vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" make test commands execute using kitty
let test#strategy = 'vtr'
let test#enabled_runners = ["ruby#rspec"]
let test#ruby#rspec#executable = 'bundle exec rspec'
"
"}}}
"