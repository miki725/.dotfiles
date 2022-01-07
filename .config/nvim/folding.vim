" http://vimcasts.org/episodes/how-to-fold/
set foldmethod=syntax
nnoremap <Space> za
set foldlevel=1

autocmd FileType vim set foldmethod=marker
autocmd FileType vim set foldlevel=0
autocmd FileType terraform set foldmethod=syntax
autocmd FileType terraform set foldlevel=0
