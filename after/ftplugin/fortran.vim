setlocal suffixesadd+=.fl  " Add Fortran Linda files
setlocal shiftwidth=4 tagrelative
setlocal ignorecase smartcase
let b:fortran_do_enddo = 1  " Enable indentation for all do loops; I can fix non-do-enddo loops manually
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePost * silent :execute "!cd \"%:p:h\"; ctags-lock --sort=foldcase -R . >/dev/null 2>&1 &"
