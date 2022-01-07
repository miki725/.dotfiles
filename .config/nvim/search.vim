" highligh search results and make search case insensitive
set hlsearch
" incremental search
set incsearch
" insensitive case
set ic
" allow to disable seach highlight with leader+h
:nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" use very magic mode by default
" https://vim.fandom.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
" nnoremap / /\v
" vnoremap / /\v
" cnoremap %s/ %smagic/
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//
