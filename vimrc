" Initialize Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Set g:VIMHOME, the top-level directory of the user's Vim files.
if !exists('g:VIMHOME')
    let g:VIMHOME=expand("<sfile>:p:h")
endif

" Determine if Vim has fully started up to skip actions in the vimrc that can't
" be done after startup.
augroup vim_started
    autocmd!
    autocmd VimEnter * let g:vim_started = 1
augroup END

" Basic options
if !exists('g:vim_started')
    set encoding=utf-8              " Make UTF-8 the default
end
set hlsearch                    " Highlight search results
set incsearch                   " Do incremental searching
set showmatch                   " Show matching brackets on insert
syntax on                       " Syntax highlighting
filetype plugin indent on       " Filetype detection
set autoindent                  " Enable autoindent if no indent plugin found
set backspace=indent,eol,start  " Backspace over everything in insert mode
set backup                      " Keep a backup file
set history=50                  " Keep 50 lines of command line history
set ruler                       " Show the cursor position all the time
set showcmd                     " Display incomplete commands
set wildmenu                    " Display tab-completion commands above
set scrolloff=3                 " Keep edge of screen away from cursor
set laststatus=2                " Alsways show status bar
set foldmethod=marker

" Show invisible characters
set list
set listchars=tab:▸\ ,trail:·,nbsp:·

" Keyboard shortcuts
" * Set leader to <space>
let mapleader = " "
" * Make Y behave like other capitals
map Y y$
" * Clear highlighting
nnoremap <leader><space> :noh<cr>
" Easier access to :
noremap <leader>; :
noremap <leader>: :

" * Select all text in buffer
map <Leader>a ggVG

" Close buffer without closing split
function! s:bdelete_DontCloseSplit()
    " Make sure we can close the buffer if there's no previous buffer
    if bufnr("#") == bufnr("%")
        exe "bdelete %"
    else
        exe "bprevious | bdelete #"
    endif
endfunc
nnoremap Q :call<space><SID>bdelete_DontCloseSplit()<CR>

" In insert mode, CTRL-U deletes the current line, while CTRL-W deletes the
" previous word. Neither of these can be recovered by using Vim undo unless
" CTRL-G u is used to break the undo block created by an insert mode command.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Map :E to :Explore to speed up directory exploration
command E Explore

" Capture Vim command output in buffer for easier navigation
" (<http://vim.wikia.com/wiki/Capture_ex_command_output>).
function! TabMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    tabnew
    silent put=message
    set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
command! -nargs=+ -complete=command VO call TabMessage(<q-args>)

" Use matchit plugin (enables using % to switch between more than just
" brackets based on the current file type)
runtime macros/matchit.vim

" Expand menu as in bash (i.e., complete up to the point of ambiguity and
" display alternatives)
set wildmode=list:longest

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse') | set mouse=a | endif
" Force vim to recoginize mouse
if !has('nvim')
    set ttymouse=xterm2
endif

" Line numbering
set number relativenumber
autocmd Colorscheme *
        \ highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE

" Colorscheme selection:
let g:myguicolor = "zenburn"
let g:myguibg = "dark"
let g:mytermcolor = g:myguicolor
let g:mytermbg = g:myguibg
let g:zenburn_high_Contrast=1

if has('autocmd')
    augroup colorscheme
        autocmd!
        autocmd Colorscheme *
            \ if &background == "light" |
                \ highlight OverLength guibg=#FFD9D9 guifg=DarkSlateGray
                    \ ctermbg=red ctermfg=white |
            \ else |
                \ highlight OverLength guibg=#592929
                    \ ctermbg=darkred ctermfg=white |
            \ endif
    augroup END
endif

if has("gui_running")
    execute "set background=" . g:myguibg . " | colorscheme " . g:myguicolor
else
    execute "set background=" . g:mytermbg
    if &t_Co >= 88
             execute "colorscheme " . g:mytermcolor
    else
        "" Disable annoying message from CSApprox on terminals with few colors
        "" -- the differing colorscheme will be enough of a clue to me that Vim
        "" didn't detect at least 88 colors.
        let g:CSApprox_loaded = 1
        colorscheme default
    endif
endif

" Show long lines
function! Match_OverLength_getTextwidth()
    if exists('b:match_OverLength_textwidth')
        return b:match_OverLength_textwidth
    elseif exists('g:match_OverLength_textwidth')
        return g:match_OverLength_textwidth
    elseif &textwidth > 0
        return &textwidth
    endif
    return 80
endfunc

let g:match_OverLength_disabled_filetypes = []
function! Match_OverLength_enable()
    if !exists('g:match_OverLength_disabled_filetypes') ||
                \ index(g:match_OverLength_disabled_filetypes, &filetype) == -1
        call Match_OverLength_force_enable()
    endif
endfunc

function! Match_OverLength_force_enable()
    execute 'setlocal colorcolumn=' .
                \ join(map(range(1, 1),
                \      "Match_OverLength_getTextwidth() + v:val"),
                \      ",")
endfunc

function! Match_OverLength_disable()
    setlocal colorcolumn&
endfunc

" Make column highlighting more subdued in terminal
if !has("gui_running")
    autocmd BufEnter * highlight ColorColumn ctermbg=237
endif

if has('autocmd')
    augroup match_OverLength
        autocmd!
        autocmd BufWinEnter *
            \ call Match_OverLength_enable()
        autocmd BufWinLeave *
            \ call Match_OverLength_disable()
    augroup END
endif

call add(g:match_OverLength_disabled_filetypes, '')
call add(g:match_OverLength_disabled_filetypes, 'help')
call add(g:match_OverLength_disabled_filetypes, 'markdown')

if has("autocmd")
    augroup vimrcEx
        autocmd!
        " Change the current working directory of the window in which a
        " file is being edited to the file's directory.
        " (Do not change it if we're editing a remote file.)
        autocmd BufEnter *
                    \ if bufname("") !~ '\v^[A-Za-z0-9]+:[\\/]{2}' |
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
endif

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
"" Haskellmode: {{{
"" Set default browser and Haddock index for documentation browsing
if has('win32') || has('win64')
    let g:haddock_browser = 'start'
elseif has('macunix')
    let g:haddock_browser = 'open'
else
    let g:haddock_browser = 'xdg-open'
endif
let g:haddock_indexfiledir = g:VIMHOME . '/.haddock_index/'
"" }}}

"" Ultisnips: {{{
" Use bindings that work with YouCompleteMe
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsListSnippets = "<F5>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
"" }}}

"" Vim-LaTeX: {{{
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a single file. This will confuse Latex-Suite. Set your grep
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
"" }}}

"" Ack configuration: {{{
"" Use ack as grep if available, and also configure ack.vim
" Detect presence of Ubuntu/Debian ack-grep
if executable("ack")
    let s:ack_exe="ack"
elseif executable("ack-grep")
    let s:ack_exe="ack-grep"
endif

if exists("s:ack_exe") && (s:ack_exe) > 0
    let g:ackprg = s:ack_exe . ' -H --nocolor --nogroup --column'
    let &g:grepprg = s:ack_exe . ' -H --nocolor --nogroup --column'
    let &g:grepformat = '%f:%l:%c:%m'
endif
"" }}}

"" Rust: {{{
" Disable conceal
let g:no_rust_conceal=1
"" }}}

"" Markdown: {{{
" Map *.md to Markdown
au BufWinEnter,BufRead,BufNewFile  *.md set filetype=markdown
"" }}}

"" Unix shell: {{{
" Don't show error for $(...)
let g:is_posix = 1
" }}}

"" Netrw: {{{
let g:netrw_keepdir = 0

" Auxilliary function to get the value of a Windows shell or environment
" variable (needed because Vim can't expand environment variable names
" containing some special characters, such as the `)` in `ProgramFiles(x86)`.
function! s:expand_win32_var(var)
    let varesc = shellescape(a:var)
    " The `set` command returns all variables that start with the given name,
    " so use the shell to grab only the line that contains `var=`, if it
    " exists.
    " Tricks:
    " - The first `[0:-2]` strips the closing quote from `varesc` to add the
    "   `=` at the end. We also add back the closing quote.
    " - The second `[0:-2]` strips the trailing newline from the result of
    "   the shell command.
    let setout = system('set ' . varesc . ' | find /I ' . varesc[0:-2] . '="')[0:-2]
    " An empty result means the variable was not found -- we return the empty
    " string in this case.
    if len(setout) == 0
        return ""
    endif
    " Since the `set` command prints output of the form `name=value`,
    " delete everything up to and including the first `=` to get just the
    " value.
    return substitute(setout, '\v^.{-}\=', '', '')
endfunc

" Configuration for Windows using PuTTY or Cygwin
if has('win32')  " Also true for 64-bit Vim
    "" Per-system configuration that may need to be customized
    let g:netrw_cygwin = 0
    let s:cygdir = 'C:\cygwin\'
    " Get PuTTY's installation directory
    if has('win64')
        let s:pf86 = s:expand_win32_var('ProgramFiles(x86)')
    else
        let s:pf86 = s:expand_win32_var('ProgramFiles')
    endif
    let s:puttydir = s:pf86 . '\PuTTY\'
    "" End custom configuration
    if g:netrw_cygwin
        let g:netrw_list_cmd = shellescape(s:cygdir . '\usr\bin\ssh') . ' USEPORT HOSTNAME ls -Fa '
        let g:netrw_ssh_cmd = shellescape(s:cygdir . '\usr\bin\ssh')
        let g:netrw_scp_cmd = shellescape(s:cygdir . '\usr\bin\scp') . ' -q'
        let g:netrw_sftp_cmd = shellescape(s:cygdir . '\usr\bin\sftp')
    else
        let g:netrw_list_cmd = shellescape(s:puttydir . '\plink') . ' USEPORT HOSTNAME ls -Fa '
        let g:netrw_ssh_cmd = shellescape(s:puttydir . '\plink')
        let g:netrw_scp_cmd = shellescape(s:puttydir . '\pscp') . ' -q'
        let g:netrw_sftp_cmd = shellescape(s:puttydir . '\psftp')
    endif
endif
"" }}}

"" Slimv: {{{
" MIT Scheme and Chicken have builtin SWANK that works.
let g:scheme_builtin_swank = 1

let g:slimv_impl = 'chicken'

let g:slimv_repl_simple_eval = 0
"" }}}

"" Jupyter/IPython: {{{
" Jupyter/IPython notebooks are internally JSON.
au BufWinEnter,BufRead,BufNewFile  *.ipynb set filetype=json
"" }}}

"********************"
"** LOCAL SETTINGS **
"********************"
let s:vimrc_local = $HOME . '/.vimrc.local'
if filereadable(s:vimrc_local)
    execute "source " . s:vimrc_local
endif
