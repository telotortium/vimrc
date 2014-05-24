" Caches temporary files under g:VIMHOME
" Copyright Robert Irelan, 2014
if exists("g:vimhome_cache_loaded") || &cp
    finish
endif
let g:vimhome_cache_loaded = 1

if exists("g:vimhome_cache_use_local") && !g:vimhome_cache_use_local
    finish
endif

let s:vars = { 'backupdir': join([ g:VIMHOME, '.cache', 'backupdir' ], '/')
    \ , 'directory': join([ g:VIMHOME, '.cache', 'directory' ], '/')
    \ , 'undodir': join([ g:VIMHOME, '.cache', 'undodir' ], '/') }
for s:var in keys(s:vars)
    let s:vardir = s:vars[s:var]
    if filewritable(s:vardir) != 2
        call mkdir(s:vardir, 'p')
    endif
    execute 'let &' . s:var . ' = join([s:vardir, &' . s:var . '], ",")'
endfor
