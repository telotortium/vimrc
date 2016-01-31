autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
