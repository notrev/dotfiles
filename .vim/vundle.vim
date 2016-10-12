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
"let g:Powerline_symbols = 'unicode'
set laststatus=2
if match($TERM, "screen*") != -1 || match($TERM, "xterm*") != -1
    set term=xterm-256color
    set t_Co=256 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
endif

" YouCompleteMe - Code autocompletion
Bundle 'Valloric/YouCompleteMe'

" Emmet - HTML expansion
Bundle 'mattn/emmet-vim'

" VIM-LESS - LESS, CSS compiler
Bundle 'groenewege/vim-less'

" Syntastic - Syntax validation
Bundle 'scrooloose/syntastic'

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "\u2717\u2717"
let g:syntastic_warning_symbol = "\u26A0\u26A0"
let g:syntastic_style_error_symbol = "\u054F\u2717"
let g:syntastic_style_warning_symbol = "\u054F\u26A0"

" HTML5.vim - Support for HTML5 Tags and attributes
Bundle 'othree/html5.vim'

" OmniSharp - CSharp autocompletion
Bundle 'OmniSharp/omnisharp-vim'

" NERDTree
Bundle 'scrooloose/nerdtree'

map ,n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" VIM-Polyglot
Bundle 'sheerun/vim-polyglot'

let g:javascript_plugin_jsdoc = 1

