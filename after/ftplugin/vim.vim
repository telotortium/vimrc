setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions=croq1t
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
