if executable('rg')
    let g:ctrlp_user_command = 'rg %s/{,.}* --files --color=never --glob "" 2> /dev/null'
endif
" caching can be disabled which can help if files are added
" but overall it makes ctrlp faster...
" let g:ctrlp_use_caching = 0
