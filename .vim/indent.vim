" default tab config - customized with autocmd below per file type
" http://vimcasts.org/episodes/tabs-and-spaces/
set ts=4 sts=4 sw=4 expandtab

" preserve existing indent for new lines
set autoindent
set smartindent

" allow backspace to remove indent, etc
set backspace=indent,eol,start

" syntax of these languages is fussy over tabs Vs spaces
autocmd BufRead,BufNewFile Makefile.* set filetype=make
autocmd BufRead,BufNewFile *.yml.j2 set filetype=yaml
autocmd BufRead,BufNewFile *.sh.j2 set filetype=sh
autocmd BufRead,BufNewFile *.r2py set filetype=python
autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType tf setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType md setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType fish setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType ini setlocal ts=4 sts=4 sw=4 expandtab
