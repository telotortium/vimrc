" Initialize Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Filetype and syntax highlighting
syntax on
filetype plugin indent on

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
" Force vim to recoginize mouse
set ttymouse=xterm2

" Colorscheme
let g:myguicolor = "zenburn"
let g:mytermcolor = g:myguicolor
let g:zenburn_high_Contrast=1
execute "colorscheme ".g:mytermcolor
if has("gui_running") 
  if has('autocmd')
      autocmd BufEnter *
      \   execute "colorscheme ".g:myguicolor
  else
  	colorscheme nuvola
  endif
endif
