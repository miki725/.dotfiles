" Install vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Define plugins.
" Can use :PlugInstall to install missing deps and :PlugClean to remove old plugins
call plug#begin('~/.vim/plugged')
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'itchyny/vim-gitbranch'
Plug 'Yggdroot/indentLine'
Plug 'Konfekt/FastFold'
Plug 'miki725/vim-ripgrep'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

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
call plug#end()
