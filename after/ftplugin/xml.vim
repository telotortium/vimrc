" Use xmllint to indent if available
if executable('xmllint')
	setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
endif
