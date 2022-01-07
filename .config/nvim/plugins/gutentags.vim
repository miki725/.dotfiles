" let g:gutentags_ctags_tagfile = '.git/tags'
if executable("fd")
    let g:gutentags_file_list_command = 'fd'
endif
