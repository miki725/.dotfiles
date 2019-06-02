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
Plug 'jremmen/vim-ripgrep'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'

Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'

Plug 'vim-scripts/fish-syntax'

Plug 'ekalinin/Dockerfile.vim'

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

Plug 'rhysd/committia.vim'
Plug 'hotwatermorning/auto-git-diff'
Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()
