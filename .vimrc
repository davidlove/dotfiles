" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Pathogen (for VIM < 8.0)
if version < 800
    execute pathogen#infect()
endif

" Readable colorscheme
set bg=dark
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Leader and local leader
let mapleader="\<Space>"
let maplocalleader=','

" Backup settings
set backup                     " keep a backup file
set backupdir-=.               " Remove current directory from backups
set backupdir^=$HOME/tmp,$TEMP " Save backups to temporary directory

set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set cursorline  " Show the line of the cursor
set showcmd     " display incomplete commands
set incsearch   " do incremental searching

" Use jk to get out of insert, visual, command
inoremap jk <Esc>
" inoremap <Esc> <nop>
vnoremap jk <Esc>
" vnoremap <Esc> <nop>
cnoremap jk <C-c>
" cnoremap <Esc> <nop>

" Fancy relative numbering from https://jeffkreeftmeijer.com/vim-number/
set number relativenumber

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv
" Allows to search by visual selection with //
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    autocmd!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup end

" Paste mode {{{
augroup leavepaste
    autocmd!

    autocmd InsertLeave * set nopaste
    nnoremap <Leader>i :set paste<CR>i
    nnoremap <Leader>I :set paste<CR>I
    nnoremap <Leader>a :set paste<CR>a
    nnoremap <Leader>A :set paste<CR>A
    nnoremap <Leader>o :set paste<CR>o
    nnoremap <Leader>O :set paste<CR>O
    nnoremap <Leader>c :set paste<CR>c
    nnoremap <Leader>C :set paste<CR>C
    nnoremap <Leader>r :set paste<CR>r
    nnoremap <Leader>R :set paste<CR>R
    nnoremap <Leader>s :set paste<CR>s
    nnoremap <Leader>S :set paste<CR>S
augroup end
" }}}

" Spelling {{{
augroup spell
    autocmd FileType text,markdown setlocal spell spelllang=en_us
    hi clear SpellBad
    hi SpellBad cterm=underline
    hi SpellBad gui=undercurl
augroup end " spell
" }}}

" Tabs {{{
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set smarttab        " Delete spaces as tabs at line beginning
set shiftround      " Round to indent when using < or >

augroup keepTabs
    autocmd!
    autocmd FileType sas setlocal noexpandtab
    autocmd FileType sql setlocal noexpandtab
    autocmd FileType make setlocal noexpandtab
augroup end
" }}}

" Set up font size {{{
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h12:cANSI
    endif
endif
" }}}

" Set F4 to toggle paste mode
set pastetoggle=<F4>

" Folding {{{
set foldmethod=syntax
set foldnestmax=10
set foldenable
set foldlevel=0
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_import = 0

augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END

" }}}

" VIM file settings {{{
augroup vimrc
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup end
" }}}

" Git commit file settings {{{
augroup gitcommit
    autocmd!
    autocmd FileType gitcommit setlocal nofoldenable
augroup END
" }}}

" Todo.txt {{{
" Use todo#Complete as the omni complete function for todo files
augroup todoMods
    autocmd!
    autocmd BufNewFile,BufRead [Tt]odo_*.txt set filetype=todo
    au filetype todo setlocal omnifunc=todo#Complete
    au filetype todo imap <buffer> + +<C-X><C-O><C-P>
    au filetype todo imap <buffer> @ @<C-X><C-O><C-P>

    let g:Todo_fold_char='+'
augroup end
let g:Todo_txt_prefix_creation_date=1
" }}}

" NERDtree {{{
" open with ctrl-o
map <C-o> :NERDTreeToggle<CR>
" }}}

" Learn VIMscript the Hard Way commands {{{"
"""""""""""""""""""""""""""""""""""""""""
" Move lines up or down by one
nnoremap <leader>- ddp
nnoremap <leader>_ ddkP

" Set to upper case
nnoremap <C-u> viwU
inoremap <C-u> <Esc>viwUea

" Edit vimrc
nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

" }}}

" statusline {{{
function SetFocusedStatusLine()
    setlocal statusline=
    setlocal statusline+=%#PmenuSel#
    setlocal statusline+=%{FugitiveStatusline()}\  "Git branch
    setlocal statusline+=%#PmenuThumb#
    setlocal statusline+=%.30f    " File path
    setlocal statusline+=%m       " Modified flag
    setlocal statusline+=%r       " Read-only flag
    setlocal statusline+=%#StatusLineNC#
    setlocal statusline+=%=       " Switch to right side
    setlocal statusline+=%#PmenuThumb#
    setlocal statusline+=%y\      " Filetype
    setlocal statusline+=%{&fileformat}\  " Line endings file format
    setlocal statusline+=\|\  " Line endings file format
    setlocal statusline+=%{&fileencoding?&fileencoding:&encoding}\  " File encoding
    setlocal statusline+=%#PmenuSel#
    setlocal statusline+=%p%%\    " Percentage through file
    setlocal statusline+=%4l/%L\ \|\ %-2c  " Line and column number, total lines
endfunction
function SetUnFocusedStatusLine()
    setlocal statusline=
    setlocal statusline+=%#LineNr#
    setlocal statusline+=%{FugitiveStatusline()}\  "Git branch
    setlocal statusline+=%.30f    " File path
    setlocal statusline+=%m       " Modified flag
    setlocal statusline+=%r       " Read-only flag
    setlocal statusline+=%=       " Switch to right side
    setlocal statusline+=%y\      " Filetype
    setlocal statusline+=%{&fileformat}\  " Line endings file format
    setlocal statusline+=\|\  " Line endings file format
    setlocal statusline+=%{&fileencoding?&fileencoding:&encoding}\  " File encoding
    setlocal statusline+=%p%%\    " Percentage through file
    setlocal statusline+=%4l/%L\ \|\ %-2c  " Line and column number, total lines
endfunction

set laststatus=2

augroup statuslinetoggle
    autocmd!
    autocmd BufEnter,FocusGained * call SetFocusedStatusLine()
    autocmd BufLeave,FocusLost   * call SetUnFocusedStatusLine()
augroup END
" }}}
