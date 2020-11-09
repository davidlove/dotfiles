" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Readable colorscheme
"set background=dark
if has('gui_running')
    let g:solarized_termcolors=256
else
    let g:solarized_termcolors=16
endif
colorscheme solarized

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Local leader to <space>
let mapleader="\<Space>"
let maplocalleader=','

" Backup settings
set backup                     " keep a backup file
set backupdir-=.               " Remove current directory from backups
set backupdir^=$HOME/tmp,$TEMP " Save backups to temporary directory

set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching

" Use jk to get out of insert mode
inoremap jk <Esc>
inoremap <Esc> <nop>

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

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

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
    augroup END
else
    set autoindent  " always set autoindenting on
    set smartindent
endif " has("autocmd")

set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces
set smarttab        " Delete spaces as tabs at line beginning
set shiftround      " Round to indent when using < or >

"Don't expand tabs for .sas, .sql
if has("autocmd")
    autocmd FileType sas setlocal noexpandtab
    autocmd FileType sql setlocal noexpandtab
    autocmd FileType make setlocal noexpandtab
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

" Set up font size
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h12:cANSI
    endif
endif

" Set F4 to toggle paste mode
set pastetoggle=<F4>

" Folding
set foldmethod=syntax
set foldnestmax=10
set foldenable
set foldlevel=0
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_import = 0

" Pathogen (for VIM < 8.0)
if version < 800
    execute pathogen#infect()
endif

" Todo.txt
" Use todo#Complete as the omni complete function for todo files
au filetype todo setlocal omnifunc=todo#Complete
au filetype todo imap <buffer> + +<C-X><C-O><C-P>
au filetype todo imap <buffer> @ @<C-X><C-O><C-P>
let g:Todo_txt_prefix_creation_date=1


" Lightline
set laststatus=2
let g:lightline = {'colorscheme': 'solarized'}

" NERDtree open with ctrl-o
map <C-o> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""
" Learn VIMscript the Hard Way commands "
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
