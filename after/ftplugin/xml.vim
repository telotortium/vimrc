" Use xmllint to indent if available
if executable('xmllint')
    if has('unix')
        setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
    else
        setlocal equalprg=xmllint\ --format\ --recover\ -
    endif
endif
