let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" requires itchyny/vim-gitbranch
let g:airline_section_b = '%{gitbranch#name()}'
