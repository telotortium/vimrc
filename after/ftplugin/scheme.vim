setlocal lisp
setlocal textwidth=79 formatoptions+=croq1j
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
