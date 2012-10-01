autocmd BufNewFile,BufRead *.m,*A.ROU call s:IsMumps()

func! s:IsMumps()
	let n = 1
	while n < 15
		let line = getline(n)
		" Look for MUMPS comments (begin with ';')
		" and indentation ('.')
		if line =~ '^\s*;' || line =~ '^\s*\.'
			setlocal filetype=mumps
			syntax clear
			syntax enable
			return
		endif
		let n += 1
	endwhile
endfunc

