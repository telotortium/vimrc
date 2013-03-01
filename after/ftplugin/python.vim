setlocal tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions=croq1t tagrelative
setlocal omnifunc=pythoncomplete#Complete  " Omnicompletion for Python
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufWritePost <buffer> silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=yes -R . '>/dev/null 2>&1' | at now")
