scriptencoding utf-8
set encoding=utf-8

syntax enable
set termguicolors
colorscheme monokai
set mouse=a

set splitright
set splitbelow

set nowrap

" paste from clipboard
" https://medium.com/swlh/8-vim-tricks-that-will-take-you-from-beginner-to-expert-817ff4870245
set clipboard=unnamed
set clipboard+=unnamedplus

" show line numbers
set number
" highlight current line
set cursorline
" show right margin at 120 chars
set colorcolumn=120
autocmd FileType markdown setlocal colorcolumn=80

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

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" clear scrollback completely when in terminal
if exists('##TermOpen')
    " start terminal in insert mode
    autocmd TermOpen * startinsert

    command! CS call ClearScrollback()
    autocmd TermOpen * setlocal scrollback=-1
    autocmd TermOpen * tnoremap <leader><c-k> <C-l><C-\><C-n>:CS<CR><s-a>
    autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
endif

" https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
endif

" copy current file name (relative/absolute) to system clipboard (Linux version)
if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  " relative path (src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%")<CR>

  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cF :let @+=expand("%:p")<CR>

  " filename (foo.txt)
  nnoremap <leader>ct :let @+=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @+=expand("%:p:h")<CR>
endif

" configuring neovim host python {{{
function! s:SetPythonHostProg(job_id, data, event)
    if (len(a:data[0]) > 0)
        execute(a:data[0])
        " call append(line('$'), a:data[0])
    endif
endfunction

" jobstart is only in neovim
if exists("*jobstart")
    let _ = jobstart(['neovim2.sh', '--vim'], {'on_stdout': function('s:SetPythonHostProg')})
    let _ = jobstart(['neovim3.sh', '--vim'], {'on_stdout': function('s:SetPythonHostProg')})
endif
" }}}

" security {{{
" https://github.com/gopasspw/gopass/blob/master/docs/setup.md#securing-your-editor
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /private/**/gopass** setlocal noswapfile nobackup noundofile
" }}}

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
    if &scrollback == 1
        set scrollback=-1
    else
        set scrollback=1
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
