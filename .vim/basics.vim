scriptencoding utf-8
set encoding=utf-8

syntax enable
set termguicolors
colorscheme monokai
set mouse=a

set nowrap

" paste from clipboard
" https://medium.com/swlh/8-vim-tricks-that-will-take-you-from-beginner-to-expert-817ff4870245
set clipboard=unnamed
set clipboard=unnamedplus

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

" spell check words
autocmd FileType markdown set spell

" allow to cycle from hidden buffers - with unsaved changes
" http://vimcasts.org/episodes/working-with-buffers/
set hidden

" open fish by default
set shell=fish

" enable file type detection
filetype on

" maximize current buffer
nnoremap <C-\> :call ToggleMaximize()<CR>

" automatically strip trailing whitespace
autocmd BufWritePre * :call <SID>PreserveCursorPosition("%s/\\s\\+$//e")

" clear scrollback completely when in terminal
if exists('##TermOpen')
    command! CS call ClearScrollback()
    autocmd TermOpen * setlocal scrollback=-1
    autocmd TermOpen * tnoremap <c-h> <C-l><C-\><C-n>:CS<CR><s-a>
endif

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

" toggle scrollback which allows to clear scrollback in terminal in neovim
function! ToggleScrollback(...)
    if &scrollback == 0
        set scrollback=-1
    else
        set scrollback=0
    endif
endfunction

function! ClearScrollback()
    call ToggleScrollback()
    let timer = timer_start(5, 'ToggleScrollback', {'repeat': 1})
endfunction

let s:maximized = 0
function! ToggleMaximize()
    if s:maximized
        wincmd =
        let s:maximized = 0
    else
        wincmd |
        wincmd _
        let s:maximized= 1
    endif
endfunction
" }}}
