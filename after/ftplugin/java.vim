setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions+=croq1j tagrelative
let java_highlight_java_lang_ids = 1
let java_highlight_functions = "style"
let java_minlines = 50

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
