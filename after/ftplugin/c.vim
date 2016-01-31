setlocal tabstop=8 softtabstop=4 textwidth=79 formatoptions+=croq1t tagrelative
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
