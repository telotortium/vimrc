setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions=croq1 tagrelative
setlocal omnifunc=pythoncomplete#Complete  " Omnicompletion for Python
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
