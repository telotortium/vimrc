setlocal tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions=croq1t tagrelative
setlocal omnifunc=pythoncomplete#Complete  " Omnicompletion for Python
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePost * silent :execute "!cd \"%:p:h\"; ctags-lock * >/dev/null 2>&1 &"
