set nocompatible cmdheight=1
execute 'source ' . expand('<sfile>:p:h') . '/plugged/vim-bracketed-paste/plugin/bracketed-paste.vim'
execute 'source ' . expand('<sfile>:p:h') . '/plugged/vim-oscyank/plugin/oscyank.vim'
let g:saved_t_ti=&t_ti
let g:saved_t_te=&t_te
set t_ti= t_te=
function! s:CheckMode()
  if v:event["new_mode"] =~ '^cv'
    set t_ti= t_te=
  else
    let &t_ti=g:saved_t_ti
    let &t_te=g:saved_t_te
  endif
endfunction
autocmd ModeChanged * call s:CheckMode()
