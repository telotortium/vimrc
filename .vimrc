" Initialize Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Filetype and syntax highlighting
syntax on
filetype plugin indent on

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
