setlocal tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab textwidth=79
    \ formatoptions+=croq1j tagrelative
let java_highlight_java_lang_ids = 1
let java_highlight_functions = "style"
let java_minlines = 50

" %-matching. <:> is handy for generics.
set matchpairs+=<:>
" There are two minor issues with it; (a) comparison operators in expressions,
" where a less-than may match a greater-than later on—this is deemed a trivial
" issue—and (b) Comments/strings. This latter issue is irremediable from the
" highlighting perspective (built into Vim), but the actual % functionality
" can be fixed by this use of matchit.vim.
let b:match_skip = 's:comment\|string'
source $VIMRUNTIME/macros/matchit.vim

autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
if has('unix') && executable('ctags-lock')
            \ && match(expand('%:p:h'), '\%^\w\+:\/\/') == -1  " No cd to URIs
    autocmd BufWritePost <buffer> silent call
        \ system("printf '%s\\n' " . shellescape(
        \   'cd ' . shellescape(expand('%:p:h'))
        \   . "; ctags-lock --sort=yes -R . >/dev/null 2>&1"
        \) . " | at now")
endif
