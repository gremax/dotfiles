" ================ Plugins ==================== {{{
"
call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'vimwiki/vimwiki'
call plug#end()
"
"}}}
"
" ================ General Config ==================== {{{
"
let g:mapleader = ","                                                           " Change leader to a comma

" set hidden                                                                      " Hide buffers in the background instead of closing them
set path+=**
"
" ================ Indentation ====================== {{{
"
set colorcolumn=120
set expandtab                                                                   " Convert tabs to spaces
set list                                                                        " Enable listchars
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮                 " Set trails for tabs and space
set nofoldenable                                                                " Disable folding by default
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
colorscheme nord                                                                " Theme
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
" [*] NerdTree
"
" Open NERDTree
nnoremap <Space><Space> :NERDTreeToggle<CR>
" Find current file in NERDTree
nnoremap <Leader>hf :NERDTreeFind<CR>
"
" [*] FZF
"
" Toggle git files list
nnoremap <C-p> :GFiles<CR>
" Toggle buffer list
nnoremap <C-x> :Buffers<CR>
"
" [*] Grepper
"
" Toggle Grepper
nnoremap <Leader>a :Grepper -tool ag<CR>
"
" [*] vim-wiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]"
" 
"
"}}}
