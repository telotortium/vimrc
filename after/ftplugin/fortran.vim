setlocal suffixesadd+=.fl  " Add Fortran Linda files
setlocal shiftwidth=4 tagrelative
setlocal ignorecase smartcase
let b:fortran_do_enddo = 1  " Enable indentation for all do loops; I can fix non-do-enddo loops manually
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufWritePost <buffer> silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=foldcase -R . '>/dev/null 2>&1' | at now")
