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

" Editor preferences
syntax on
set ts=4                    " Defines tab stop to 4 spaces
set ai                      " Defines Auto-Indentation
set sw=4                    " Number of spaces for each step of auto-ident
set number                  " Shows the line numeration
set expandtab               " Changes shifttab for spaces
set softtabstop=4           " let backspace delete indent
set pastetoggle=<F2>        " Turns paste mode on or off. Used to paste text in vim
"set background=light
set guifont=MesloLGM\ Nerd\ Font\ RegularForPowerline\ 12

" Searching preferences
set hlsearch           " highlight the last used search pattern
set incsearch          " Incomplete search, show results while typing
set ignorecase         " Case-insensitive search
set smartcase          " case-sensitive if search contains an uppercase char
" Change colors of highlighted word on search
"highlight Search ctermbg=blue ctermfg=white

set showcmd
set lazyredraw

"let mapleader=','

" Set colorscheme
colorscheme monokai

" Clear search highlight with ',h' keys in normal mode
nmap ,h :nohlsearch<CR>

" Copy visual selection to clipboard
vnoremap ,y "+y

" Paste from clipboard
vnoremap ,p "+p

" Force write command
command! WW w !sudo tee %

" Persistent undo
if has('persistent_undo')
    set undofile                " set persistent undo ...
    set undolevels=1000         " max number of changes that can be undone
    set undoreload=10000        " max lines to save for undo on a buffer reload
    set undodir=/home/$USER/.vim-undo-files     " where to save undo histories
endif

" Highlight collumn 81 for some types of file
"highlight ColumnMarker ctermbg=60 guibg=red
"let $columnMarkerFileTypes = 'sh,c,cpp,java,php,vim,javascript,python'
"augroup column_marker
"    au!
"    au FileType $columnMarkerFileTypes
"        \ let b:hlColumnMarker = matchadd('ColumnMarker', '\%101v', 100)
"    "au BufLeave,FileType $columnMarkerFileTypes
"    "    \ matchdelete(b:hlColumnMarker)
"    "    \ unlet b:hlColumnMarker
"augroup END

" Highlight trailing whitespaces and tabs
fun! HighlightUnwantedChars()
    " Exceptions
    if &ft =~ 'help'
        return
    endif
    call matchadd('TrailingWhiteSpace', '\s\+$', 100)
    call matchadd('UnwantedTabs', '\t', 100)
endfun

augroup unwanted_chars
    highlight TrailingWhiteSpace ctermbg=red guibg=red ctermfg=white
    highlight UnwantedTabs ctermbg=red guibg=red ctermfg=white

    au!
    au BufEnter * call HighlightUnwantedChars()
    "autocmd BufLeave * call clearmatches() " <-- fishy. TODO: fix this
augroup END

" Hightlight autocompletion window - modifying colors
"highlight Pmenu ctermbg=DarkGrey ctermfg=LightGrey
"highlight PmenuSel ctermbg=DarkBlue ctermfg=White

" Highlight cursor line and cursor line number
if exists('colors_name') && colors_name == 'monokai'
    set cursorline
    highlight CursorLineNr ctermbg=236 guibg=#383a3e
    "highlight CursorLine cterm=NONE ctermbg=Black
endif

" Closing Preview buffer after complete is done
autocmd CompleteDone * pclose

" Commenting blocks of code.
autocmd FileType c,cpp,java,php,javascript      let b:commentLeader = '// '
autocmd FileType sh,ruby,python,conf,fstab      let b:commentLeader = '# '
autocmd FileType tex                            let b:commentLeader = '% '
autocmd FileType mail                           let b:commentLeader = '> '
autocmd FileType vim                            let b:commentLeader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:commentLeader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:commentLeader,'\/')<CR>//e<CR>:nohlsearch<CR>

if has('autocmd')
    filetype plugin indent on
endif
