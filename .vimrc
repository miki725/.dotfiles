" ----------------------------------------------------------------------------
" BASICS {{{
scriptencoding utf-8
set encoding=utf-8

syntax enable
colorscheme monokai
set mouse=a

" show line numbers
set number
" highlight current line
set cursorline
" show right margin at 120 chars
set colorcolumn=120

" show hidden chars
set list
" specify how hidden chars are represented
" http://vimcasts.org/episodes/show-invisibles/
set listchars=tab:▸\ ,eol:¬

" allow to cycle from hidden buffers - with unsaved changes
" http://vimcasts.org/episodes/working-with-buffers/
set hidden
" }}}

" ----------------------------------------------------------------------------
" FOLDING {{{
" http://vimcasts.org/episodes/how-to-fold/
set foldmethod=syntax
nnoremap <Space> za
" }}}

" ----------------------------------------------------------------------------
" SEARCHING {{{
" highligh search results and make search case insensitive
set hlsearch
" incremental search
set incsearch
" insensitive case
set ic
" }}}

" ----------------------------------------------------------------------------
" INDENT {{{
" default tab config - customized with autocmd below per file type
" http://vimcasts.org/episodes/tabs-and-spaces/
set ts=4 sts=4 sw=4 expandtab

" preserve existing indent for new lines
set autoindent
set smartindent

" allow backspace to remove indent, etc
set backspace=indent,eol,start
" }}}

" ----------------------------------------------------------------------------
" NAVIGATION {{{
" easier switch between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" have %% expand current file directory
" http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" shortcut for editing files in same directory as current file
map <leader>ew :edit %%
map <leader>es :split %%
map <leader>ev :vsplit %%
map <leader>et :tabedit %%
" }}}

" ----------------------------------------------------------------------------
" FILE TYPE OVERWRITES {{{
" only do this part when compiled with support for autocommands
if has("autocmd")
    " enable file type detection
    filetype on
    " automatically strip trailing whitespace
    autocmd BufWritePre * :call <SID>Preserve("%s/\\s\\+$//e")

    " INDENT {{{
    " syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType md setlocal ts=2 sts=2 sw=2 expandtab
    " }}}

    " FOLDING {{{
    autocmd FileType vim set foldmethod=marker
    " }}}
endif
" }}}

" ----------------------------------------------------------------------------
" REFLOW {{{
" autoreflow text with par
" usage - gq
set formatprg=par\ -w79\ -q
" }}}
"
" ----------------------------------------------------------------------------
" PLUGINS {{{
let g:netrw_list_hide= '.*\.swp$,.*\.py[co]$'

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
call plug#end()
" }}}

" ----------------------------------------------------------------------------
" FUNCTIONS {{{
" function applies a command and maintains cursor position
" http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }}}
