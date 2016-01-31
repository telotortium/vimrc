setlocal suffixesadd+=.fl  " Add Fortran Linda files
setlocal shiftwidth=4 tagrelative
setlocal ignorecase smartcase
let b:fortran_do_enddo = 1  " Enable indentation for all do loops; I can fix non-do-enddo loops manually

autocmd! * <buffer>
" Highlight long lines
autocmd BufEnter <buffer> highlight fortranSerialNumber term=reverse ctermbg=DarkRed guibg=DarkRed
" Delete trailing whitespace
autocmd BufWritePre <buffer> :%s/\s\+$//e
