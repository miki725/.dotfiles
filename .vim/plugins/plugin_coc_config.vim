let g:coc_global_extensions = [
    \'coc-git',
    \'coc-highlight',
    \'coc-json',
    \'coc-python',
    \]

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>IsPreviousCharWhitespace() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" highlight {{{
" highlight current symbol
autocmd CursorHold * silent call CocActionAsync('highlight')
" highlight current symbol after Xms cursor is not moved
set updatetime=1000
" colortheme by default does not set any of the coc colors
" hence current symbol is highlighted with a pure black background
" so we adjust here
hi default CocHighlightText guifg=#eef8ff guibg=#e45c58 ctermbg=223
" }}}

" git {{{
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit ad current position
nmap gc <Plug>(coc-git-commit)
" }}}

" utility functions {{{
" check if previous character is a whitespace
function! s:IsPreviousCharWhitespace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
