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

" Line numbering
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE

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

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " Change the current working directory of the window in which a file
  " is being edited to the file's directory.
  autocmd BufEnter *
    \ if bufname("") !~ "^\[A-Za-z0-9\]*://" |
    \   lcd %:p:h |
    \ endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Other GUI-specific options
if has("gui_running")
    set guifont=Inconsolata-dz\ 8.5
    " Remove toolbar
    set guioptions-=T
endif

