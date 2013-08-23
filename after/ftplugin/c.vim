setlocal tabstop=8 softtabstop=4 textwidth=79 formatoptions+=croq1t tagrelative
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufWritePost <buffer> silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=yes -R . '>/dev/null 2>&1' | at now")
let g:c_syntax_for_h = 1
