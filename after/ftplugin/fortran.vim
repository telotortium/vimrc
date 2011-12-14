setlocal suffixesadd+=.fl  " Add Fortran Linda files
setlocal shiftwidth=4 tagrelative
setlocal ignorecase smartcase
let b:fortran_do_enddo = 1  " Enable indentation for all do loops; I can fix non-do-enddo loops manually

autocmd! * <buffer>
" Highlight long lines
autocmd BufEnter <buffer> highlight fortranLongLine term=reverse ctermbg=4 guibg=DarkRed
autocmd BufEnter <buffer> match fortranLongLine '\%>72v.\+'
" Delete trailing whitespace
autocmd BufWritePre <buffer> :%s/\s\+$//e
" Update ctags file
autocmd BufWritePost <buffer> silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=foldcase -R . '>/dev/null 2>&1' | at now")
