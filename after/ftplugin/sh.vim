setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions=croq1 tagrelative
let &l:tags = &l:tags
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
