setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions+=croq1t tagrelative
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
if has('unix') && executable('ctags-lock')
            \ && match(expand('%:p:h'), '\%^\w\+:\/\/') == -1  " No cd to URIs
    autocmd BufWritePost <buffer> silent call
        \ system("printf '%s\\n' " . shellescape(
        \   'cd ' . shellescape(expand('%:p:h'))
        \   . "; ctags-lock --sort=yes -R . >/dev/null 2>&1"
        \) . " | at now")
endif
