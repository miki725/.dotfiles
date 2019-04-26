scriptencoding utf-8
set encoding=utf-8

syntax enable
colorscheme monokai
set mouse=a
" show line numbers
set number
" highlight current line
set cursorline
" show hidden chars
set list
" specify how hidden chars are represented
" http://vimcasts.org/episodes/show-invisibles/
set listchars=tab:▸\ ,eol:¬
" highligh search results and make search case insensitive
set hlsearch
" incremental search
set incsearch
" insensitive case
set ic
" allow to cycle from hidden buffers - with unsaved changes
" http://vimcasts.org/episodes/working-with-buffers/
set hidden
" default tab config - customized with autocmd below per file type
" http://vimcasts.org/episodes/tabs-and-spaces/
set ts=4 sts=4 sw=4 expandtab
set colorcolumn=120
" autoreflow text with par
set formatprg=par\ -w79\ -q
" preserve existing indent for new lines
set autoindent
set smartindent
" allow backspace to remove indent, etc
set backspace=indent,eol,start
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

" only do this part when compiled with support for autocommands
if has("autocmd")
    " enable file type detection
    filetype on

    " syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType md setlocal ts=2 sts=2 sw=2 expandtab

    " automatically strip trailing whitespace
    autocmd BufWritePre * :call <SID>Preserve("%s/\\s\\+$//e")
endif

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

" PLUGINS
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:netrw_list_hide= '.*\.swp$,.*\.py[co]$'
