" ---------
" VUNDLE
" ---------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Self managed plugin [Required]
Bundle 'gmarik/vundle'

" ---------
" PLUGINS
" ---------

" Powerline - Bar that displays file informations
Bundle 'Lokaltog/powerline'

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'
set laststatus=2
if match($TERM, "screen*") != -1 || match($TERM, "xterm*") != -1
    set term=xterm-256color
    set t_Co=256 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
endif

" YouCompleteMe - Code autocompletion
Bundle 'Valloric/YouCompleteMe'

" Emmet - HTML expansion
Bundle 'mattn/emmet-vim'