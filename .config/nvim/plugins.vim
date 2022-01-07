
" Install vim plug if not already installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! PlugLoaded(name)
    return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

" Define plugins.
" Can use :PlugInstall to install missing deps and :PlugClean to remove old plugins
call plug#begin('~/.config/nvim/plugged')

" {{{ GENERIC

Plug 'dstein64/vim-startuptime'

Plug 'tanvirtin/monokai.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" toggle relative line number
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" shows startup screen with most recent files
Plug 'mhinz/vim-startify'

"status bar on the bottom
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" requires to show git branch in airline
" Plug 'itchyny/vim-gitbranch'
" adds git commands such as :Gdiffssplit for 3-way-merge
Plug 'tpope/vim-fugitive'
" adds Gbrowse to open file in github
Plug 'tpope/vim-rhubarb'

" shows indent indicators
Plug 'Yggdroot/indentLine'

" recomputes automatic folds on file save
" vs randomly in indert mode
" especially in markdown this is very annoying
Plug 'Konfekt/FastFold'

" maximizes buffle to fullscreen
Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle' }

" search with Rg with keybindings
Plug 'miki725/vim-ripgrep', { 'on': 'Rg' }
" saves changes to files from quickfix window
Plug 'stefandtw/quickfix-reflector.vim', { 'on': 'Rg' }
" persistent undo history of files
Plug 'simnalamburt/vim-mundo', { 'on':  [ 'MundoToggle', 'MundoShow'] }

" shows file tree
" Plug 'scrooloose/nerdtree', { 'on':  [ 'NERDTreeFind', 'NERDTreeToggle'] }
" Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  [ 'NERDTreeFind', 'NERDTreeToggle'] }

" search files with C-p
Plug 'junegunn/fzf', { 'on': ['FZF', 'GFiles', 'Buffers', 'Tags', 'BTags'], 'dir': '~/.fzf', 'do': './install --all' }
" fzf prompt only list git files
Plug 'junegunn/fzf.vim', { 'on': ['GFiles', 'Buffers', 'Tags', 'BTags'] }

" fuzzy search text with z/
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

" honors editorconfig configs
Plug 'editorconfig/editorconfig-vim'

" }}}

" Plug 'vimwiki/vimwiki'
" Plug 'mattn/calendar-vim'

" allows to nativate with readme keybindings
" in insert and normal modes - e.g. C-a, C-e
Plug 'tpope/vim-rsi'

Plug 'numToStr/Comment.nvim'

" automatically toggle comments with c-<space>
" Plug 'scrooloose/nerdcommenter'

Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }

" Plug 'sheerun/vim-polyglot'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'tmhedberg/SimpylFold', {'for': 'python'}

Plug 'puremourning/vimspector', { 'on': ['<Plug>VimspectorContinue', '<Plug>VimspectorToggleBreakpoint'] }

Plug 'kyazdani42/nvim-tree.lua'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'alvarosevilla95/luatab.nvim'
" Plug 'romgrk/barbar.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'

Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'weilbith/nvim-code-action-menu'
" Plug 'RishabhRD/popfix'
" Plug 'RishabhRD/nvim-lsputils'

Plug 'L3MON4D3/LuaSnip'

Plug 'onsails/lspkind-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'f3fora/cmp-spell'
Plug 'ray-x/cmp-treesitter'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-vsnip'
" Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

" if executable("node") && executable("yarn")
"     Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" endif

if executable("ctags")
    Plug 'ludovicchabant/vim-gutentags'
endif

" git commit window
Plug 'rhysd/committia.vim'
" for interactive rebase
Plug 'hotwatermorning/auto-git-diff'

" use neovim in the browser
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

call plug#end()
