setlocal tabstop=8 shiftwidth=4 smarttab expandtab softtabstop=4 textwidth=79 formatoptions+=croq1t tagrelative
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePost * silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=foldcase -R . '>/dev/null 2>&1' | at now")

