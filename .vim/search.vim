" highligh search results and make search case insensitive
set hlsearch
" incremental search
set incsearch
" insensitive case
set ic
" allow to disable seach highlight with leader+h
:nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
