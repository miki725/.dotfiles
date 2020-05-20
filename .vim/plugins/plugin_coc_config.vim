
let g:coc_global_extensions = [
    \'coc-git',
    \'coc-highlight',
    \'coc-json',
    \'coc-python',
    \'coc-tslint-plugin',
    \'coc-tsserver',
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

" navigation {{{
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" }}}

" git {{{
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit at current position
nmap gc <Plug>(coc-git-commit)
" }}}

" python {{{
function! SetPythonInterpreter()
    call coc#config('python', {
    \   'pythonPath': split(execute('!which python'), '\n')[-1],
    \   'linting.flake8Path': split(execute('!which flake8'), '\n')[-1],
    \   'linting.mypyPath': split(execute('!which mypy'), '\n')[-1],
    \ })
endfunction
call SetPythonInterpreter()
" }}}

" utility functions {{{
" check if previous character is a whitespace
function! s:IsPreviousCharWhitespace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
