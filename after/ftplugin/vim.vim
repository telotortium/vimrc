setlocal tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions=croq1t
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
