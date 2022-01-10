" http://vimcasts.org/episodes/how-to-fold/
" set foldmethod=syntax
nnoremap <Space> za
set foldlevel=1
" so that paragraph jumps do not open folded blocks
set foldopen-=block

autocmd FileType vim set foldmethod=marker
autocmd FileType vim set foldlevel=0
