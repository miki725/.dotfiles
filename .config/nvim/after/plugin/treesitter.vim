" folding needs to switching to nvim_treesitter
" only after treesitter loads
" otherwise either the syntax is not highlighted
" until :e or folding does not work
" https://www.reddit.com/r/neovim/comments/njew3z/treesitter_code_folding/
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
