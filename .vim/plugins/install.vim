" Install vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Define plugins.
" Can use :PlugInstall to install missing deps and :PlugClean to remove old plugins
call plug#begin('~/.vim/plugged')

" {{{ GENERIC

" shows startup screen with most recent files
Plug 'mhinz/vim-startify'

"status bar on the bottom
Plug 'vim-airline/vim-airline'
" requires to show git branch in airline
Plug 'itchyny/vim-gitbranch'

" shows indent indicators
Plug 'Yggdroot/indentLine'

" recomputes automatic folds on file save
" vs randomly in indert mode
" especially in markdown this is very annoying
Plug 'Konfekt/FastFold'

" search with Rg with keybindings
Plug 'miki725/vim-ripgrep'
" saves changes to files from quickfix window
Plug 'stefandtw/quickfix-reflector.vim'

" shows file tree
Plug 'scrooloose/nerdtree'
" search files with C-p
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Plug 'haya14busa/incsearch.vim'
" fuzzy search text with z/
Plug 'haya14busa/incsearch-fuzzy.vim'

" }}}



" allows to nativate with readme keybindings
" in insert and normal modes - e.g. C-a, C-e
Plug 'tpope/vim-rsi'

" automatically toggle comments with c-<space>
Plug 'scrooloose/nerdcommenter'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

Plug 'vim-python/python-syntax', {'for': 'python'}
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'tmhedberg/SimpylFold', {'for': 'python'}

Plug 'vim-scripts/fish-syntax', {'for': 'fish'}

Plug 'ekalinin/Dockerfile.vim', {'for': 'docker'}

Plug 'leafgarland/typescript-vim', {'for': 'typescript'}

Plug 'hashivim/vim-terraform', {'for': 'terraform'}

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'rhysd/committia.vim'
Plug 'hotwatermorning/auto-git-diff'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

call plug#end()
