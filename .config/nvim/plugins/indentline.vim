let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

" by default it is hiding some characters such as quotes
" in json file keys which is probably great but super confusing
autocmd FileType json let g:indentLine_conceallevel=0
