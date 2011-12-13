" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal tabstop=8 shiftwidth=2 smarttab expandtab softtabstop=2 textwidth=79 formatoptions=croq1t tagrelative
setlocal spell spelllang=en_us
autocmd! * <buffer>
autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufWritePost <buffer> silent call system("echo cd " . shellescape(expand('%:p:h')) . "';' ctags-lock --sort=foldcase -R . '>/dev/null 2>&1' | at now")
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:

" Set compilation rules
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_ViewRule_dvi='xdg-open'
let g:Tex_ViewRule_ps='xdg-open'
let g:Tex_ViewRule_pdf='xdg-open'

let g:Tex_UseUtfMenus=1

" Map EFE to insert \begin{frame} and \end{frame} for Beamer
call IMAP('EFE', "\\begin{frame}\<CR> \\frametitle{<++>}\<CR><++>\<CR>\\end{frame}<++>", 'tex')

