scriptencoding utf-8
set encoding=utf-8

syntax enable
set termguicolors
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
" show all characters
set conceallevel=0

" allow to cycle from hidden buffers - with unsaved changes
" http://vimcasts.org/episodes/working-with-buffers/
set hidden

" open fish by default
set shell=fish

" enable file type detection
filetype on

" automatically strip trailing whitespace
autocmd BufWritePre * :call <SID>PreserveCursorPosition("%s/\\s\\+$//e")

" utility functions {{{
" function applies a command and maintains cursor position
" http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>PreserveCursorPosition(command)
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
