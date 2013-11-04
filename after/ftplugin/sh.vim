setlocal tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions=croq1t tagrelative
let &l:tags = &l:tags
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
if has('unix')
    autocmd BufWritePost <buffer> silent call
        \ system("printf '%s\\n' " . shellescape(
        \   'cd ' . shellescape(expand('%:p:h'))
        \   . "; ctags-lock --sort=yes -R . >/dev/null 2>&1"
        \) . " | at now")
endif
