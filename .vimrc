" Initialize Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Set g:VIMHOME, the top-level directory of the user's Vim files. This should
" just be the first directory in the runtimepath at startup
if !exists('g:VIMHOME')
    let g:VIMHOME=pathogen#split(&runtimepath)[0]
endif

" Basic options
set encoding=utf-8              " Make UTF-8 the default
set hlsearch                    " Highlight search results
set incsearch                   " Do incremental searching
set showmatch                   " Show matching brackets on insert
syntax on                       " Syntax highlighting
filetype plugin indent on       " Filetype detection
set backspace=indent,eol,start  " Backspace over everything in insert mode
set backup                      " Keep a backup file
set history=50                  " Keep 50 lines of command line history
set ruler                       " Show the cursor position all the time
set showcmd                     " Display incomplete commands
set wildmenu                    " Display tab-completion commands above
set scrolloff=3                 " Keep edge of screen away from cursor
set laststatus=2                " Alsways show status bar

" Show invisible characters
set list
set listchars=tab:▸\ ,eol:¬,trail:·

" Keyboard shortcuts
" * Make Y behave like other capitals
map Y y$
" * Clear highlighting
nnoremap <leader><space> :noh<cr>
" * Remap <tab> to act like % in normal mode (switch between opening and
" * closing braces)
nnoremap <tab> %
vnoremap <tab> %
" * Allow moving between splits by pressing Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" * Select all text in buffer
map <Leader>a ggVG

" In insert mode, CTRL-U deletes the current line, while CTRL-W deletes the
" previous word. Neither of these can be recovered by using Vim undo unless
" CTRL-G u is used to break the undo block created by an insert mode command.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Use matchit plugin (enables using % to switch between more than just
" brackets based on the current file type)
runtime macros/matchit.vim

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse') | set mouse=a | endif
" Force vim to recoginize mouse
set ttymouse=xterm2

" Line numbering
set relativenumber
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE

" Colorscheme selection:
" There seems to be a bug in GVim on RedHat systems where colorschemes don't
" work correctly when they're specified from the .vimrc file: the colors are
" incorrect. Loading the colorscheme again rectifies this for the rest of the
" time the program is open. Therefore, I use an autocmd to load the
" colorscheme desired the first time a file is entered in the GUI, after which
" the autocmd can be removed.
let g:myguicolor = "zenburn"
let g:myguibg = "dark"
let g:mytermcolor = g:myguicolor
let g:mytermbg = g:myguibg
let g:zenburn_high_Contrast=1
if has("gui_running")
    if has('autocmd')
        augroup colorscheme
            au!
            autocmd BufEnter *
                        \   execute "set background=".g:myguibg
                        \   . " | colorscheme ".g:myguicolor
                        \   | au! colorscheme
        augroup END
    else
        colorscheme nuvola
    endif
elseif &t_Co > 255
    execute "set background=".g:mytermbg." | colorscheme ".g:mytermcolor
else
    set colorscheme default
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " Change the current working directory of the window in which a
        " file is being edited to the file's directory.
        autocmd BufEnter *
                    \ if bufname("") !~ "^\[A-Za-z0-9\]*://" |
                    \   lcd %:p:h |
                    \ endif

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event
        " handler (happens when dropping a file on gvim).  Also don't do it
        " when the mark is in the first line, that is the default position
        " when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent              " always set autoindenting on

endif " has("autocmd")

" Other GUI-specific options
if has("gui_running")
    if has('win32') || has('win64')
        set guifont=Consolas:h8
        " Windows doesn't seem to remember window size, so set it manually
        if &diff
            set lines=49 columns=177
        else
            set lines=49 columns=85
        endif
    else
        set guifont=Inconsolata-dz\ 8.5
    endif
    " Remove toolbar
    set guioptions-=T
endif

""" Persistent undo for Vim 7.3 and above """
if version >= 703
    let &undodir = g:VIMHOME . '/.undodir'
    set undofile
    set undolevels=1000    " maximum number of changes that can be undone
    set undoreload=10000   " maximum number of lines to save for undo
                           " on a buffer reload
endif

""" Location of swap files (modified to create from complete path in
""" non-current directory)
if has('win32') || has('win64') || has('dos16') || has('dos32')
    set directory=.,$TEMP//,$SystemDrive/tmp//,$SystemDrive/temp//,C:/tmp//,C:/temp//
else
    set directory=.,~/tmp//,/var/tmp//,/tmp//
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
if system("hostname") == "uhura.rice.edu\n"
    let g:haddock_docdir = $HOME . "/local/local6/share/doc/ghc/html"
endif


"" SnipMate: Customize author name
let g:snips_author='Robert Irelan'


"" Vim-LaTeX settings:
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Remap key to jump to next placeholder to not conflict with the <C-j> mapping
" above
imap <C-_> <Plug>IMAP_JumpForward
nmap <C-_> <Plug>IMAP_JumpForward
vmap <C-_> <Plug>IMAP_JumpForward


"" ack.vim: detect presence of Ubuntu/Debian ack-grep
if executable("ack-grep")
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
endif



