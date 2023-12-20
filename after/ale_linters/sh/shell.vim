" Enable the extglob shell option for ALE sh check.
function! ale_linters#sh#shell#GetCommand(buffer) abort
    return ale_linters#sh#shell#GetExecutable(a:buffer) . ' -O extglob -n %t'
endfunction
