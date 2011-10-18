setlocal autoindent tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions+=croq1t tagrelative
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePost * silent :execute "!cd \"%:p:h\"; ctags --append \"%\"" | redraw

