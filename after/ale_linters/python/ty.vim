" Run ty inside the Python environment selected for the buffer.

call ale#Set('python_ty_executable', get(g:, 'python_project_env', g:VIMHOME . '/bin/python-project-env'))
call ale#Set('python_ty_options', '')

function! ale_linters#python#ty#GetCommand(buffer) abort
    return 'PYTHON_PROJECT_ENV_START=' . ale#Escape(expand('#' . a:buffer . ':p')) . ' '
    \   . ale#Escape(ale#Var(a:buffer, 'python_ty_executable'))
    \   . ' ty check --no-progress --output-format concise'
    \   . ale#Pad(ale#Var(a:buffer, 'python_ty_options'))
    \   . ' %t'
endfunction

function! ale_linters#python#ty#GetCwd(buffer) abort
    return expand('#' . a:buffer . ':p:h')
endfunction

function! ale_linters#python#ty#Handle(buffer, lines) abort
    let l:pattern = '\v^(.+):(\d+):(\d+): (error|warning)\[([A-Za-z0-9_-]+)\] (.+)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'filename': expand('#' . a:buffer . ':p'),
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'type': l:match[4] is# 'error' ? 'E' : 'W',
        \   'code': l:match[5],
        \   'text': l:match[6],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('python', {
\   'name': 'ty',
\   'executable': 'ty',
\   'cwd': function('ale_linters#python#ty#GetCwd'),
\   'command': function('ale_linters#python#ty#GetCommand'),
\   'callback': 'ale_linters#python#ty#Handle',
\   'output_stream': 'both',
\})
