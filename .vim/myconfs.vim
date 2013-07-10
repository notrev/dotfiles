" ----------
" My VIM configurations
" author: Éverton Arruda <root@earruda.eti.br>
" website: http://earruda.eti.br
"
" Inspired by: http://gitorious.org/magic-dot-files/magic-dot-files
" ----------

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Editing preferences
syntax on
set ts=4		        " Defines tab stop to 4 spaces
set ai			        " Defines Auto-Indentation
set sw=4 		        " Number of spaces for each step of auto-ident
set number		        " Shows the line numeration
set expandtab 	        " Changes shifttab for spaces
set softtabstop=4       " let backspace delete indent
set pastetoggle=<F2>    " Turns paste mode on or off. Used to paste text in vim

"" Autocompletion for PHP
"if has("autocmd")
"    autocmd FileType php set complete-=k/home/$USER/.vim/doc/php-functions
"            \ complete+=k/home/$USER/.vim/doc/php-functions
"endif
"
""Autocompletion for Python
"if has("autocmd")
"    autocmd FileType python set complete+=k/home/$USER/.vim/doc/pydiction
"            \ iskeyword+=.,(
"endif

" For editing PO files
if has('autocmd')
    autocmd FileType po setlocal spell spelllang=pt
    autocmd FileType po :colorscheme delek
endif

" Persistent undo
if has('persistent_undo')
    set undofile                " so is persistent undo ...
    set undolevels=1000         " max number of changes that can be undone
    set undoreload=10000        " max lines to save for undo on a buffer reload
    set undodir=/home/$USER/.vim-undo-files     " where to save undo histories
endif

" Searching preferences
set hlsearch           " highlight the last used search pattern
set incsearch          " Incomplete search, show results while typing
set smartcase          " case-sensitive if search contains an uppercase char
    " Change colors of highlighted word on search
highlight Search ctermbg=blue ctermfg=white
    " Clear highlight with ',h' keys on normal mode
nmap ,h :nohl<CR>

" Highlight as Error characters beyond column 80
highlight MaxChars ctermbg=red guibg=red
"command Hl80 :match MaxChars /\%81v/
command Nohl80 :match None /\%81v/

" Highlight extra whitespaces and max chars
" Thanks to kurkale6ka, from #vim @ freenode
if has('autocmd')
    highlight ExtraWSAndMaxChars ctermbg=red guibg=red
    match ExtraWSAndMaxChars /\%>81v\|\s\+$/
    autocmd BufWinEnter * match ExtraWSAndMaxChars /\%>81v\|\s\+$/
    autocmd InsertEnter * match ExtraWSAndMaxChars /\%>81v\|\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWSAndMaxChars /\%>81v\|\s\+$/

    if version >= 702
        autocmd BufWinLeave * call clearmatches()
    endif
endif
