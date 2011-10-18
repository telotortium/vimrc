" Initialize Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Set g:VIMHOME, the top-level directory of the user's Vim files. This should
" just be the first directory in the runtimepath at startup
if !exists('g:VIMHOME')
	let g:VIMHOME=pathogen#split(&runtimepath)[0]
endif

" Basic options
set hlsearch               " Highlight search results
set incsearch		   " Do incremental searching
syntax on                  " Syntax highlighting
filetype plugin indent on  " Filetype detection
set backspace=indent,eol,start  " Backspace over everything in insert mode
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" In insert mode, CTRL-U deletes the current line, while CTRL-W deletes the
" previous word. Neither of these can be recovered by using Vim undo unless
" CTRL-G u is used to break the undo block created by an insert mode command.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

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

""" Persistent undo for Vim 7.3 and above """
if version >= 703
	let &undodir = g:VIMHOME . '/.undodir'
	set undofile
	set undolevels=1000 "maximum number of changes that can be undone
	set undoreload=10000 "maximum number of lines to save for undo on a buffer reload
endif

"********************"
"** PLUGIN OPTIONS **"
"********************"
" Haskellmode: Set default browser and Haddock index for documentation
" browsing
if has('win32') || has('win64')
	let g:haddock_browser = 'start'
elseif has('macunix')
	let g:haddock_browser = 'open'
else
	let g:haddock_browser = 'xdg-open'
endif
let g:haddock_indexfiledir = g:VIMHOME . '/.haddock_index'


"" Vim-LaTeX settings:
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


