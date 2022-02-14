" Auto install plugin manager
if empty(glob(stdpath('config') . '/autoload/plug.vim'))
    execute 'silent !curl -fLo ' . stdpath('config') . '/autoload/plug.vim --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Init plugin manager
call plug#begin(stdpath('config') . '/plugged')

" ---------
" PLUGINS
" ---------

" [PLUGIN] VIM-Fugitive - Git integration
Plug 'tpope/vim-fugitive'

" [PLUGIN] Lightline - Statusline that displays many informations
Plug 'itchyny/lightline.vim'

let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'fugitive', 'relativepath' ] ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightLineFugitive',
    \   'relativepath': 'LightLineFilename',
    \   'mode': 'LightLineMode',
    \   'filetype': 'MyFiletype',
    \   'fileformat': 'MyFileformat'
    \ },
    \ 'component_expand': {
    \   'readonly': 'LightLineReadonly'
    \ },
    \ 'component_type': {
    \   'readonly': 'error'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

function! LightLineModified()
    if index(["help", "nerdtree"], &filetype) >= 0
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return ""
    endif
endfunction

function! LightLineReadonly()
    if index(["help"], &filetype) >= 0
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction

function! LightLineFugitive()
    if exists("*fugitive#head")
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction

function! LightLineFilename()
    return ('' != expand('%f') ? fnamemodify(expand("%"), ":~:."): '[No Name]') .
            \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

" itchyny/lightline.vim: Show plugin name instead of normal as the mode
function! LightLineMode()
    return expand('%:t') ==# '__Tagbar__' ? 'Tagbar' :
       \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
       \ &filetype ==# 'nerdtree' ?  'NERDTree' :
       \ &filetype ==# 'unite' ? 'Unite' :
       \ &filetype ==# 'vimfiler' ? 'VimFiler' :
       \ &filetype ==# 'vimshell' ? 'VimShell' :
       \ lightline#mode()[0]
endfunction

function! LightlineLineInfo()
    if index(["nerdtree"], &filetype) >= 0
        return ""
    else
        return line(".").":". col(".")
    endif
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' .
         \ WebDevIconsGetFileTypeSymbol() : '') : ''
endfunction

function! MyFileformat()
    if index(["nerdtree"], &filetype) >= 0
        return ""
    else
        return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endif
endfunction

" [PLUGIN] YouCompleteMe - Code autocompletion
"Plug 'Valloric/YouCompleteMe', { 'do': 'rm third_party/ycmd/third_party/tern_runtime/node_modules ; python3 install.py --all' }

" Javascript GoTo keymapping
"autocmd FileType javascript nmap <buffer> <C-]> :YcmCompleter GoTo<CR>

" [PLUGIN] deoplete - Code completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

let g:deoplete#enable_at_startup = 1

" [PLUGIN] Emmet - HTML expansion
Plug 'mattn/emmet-vim', { 'for': 'html' }

" [PLUGIN] VIM-Polyglot
Plug 'sheerun/vim-polyglot'

let g:javascript_plugin_jsdoc = 1

" [PLUGIN] NERDTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

map ,n :NERDTreeToggle<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Start NERDTree when Vim is started without file arguments.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' && exists(":NERDTreeMirror") | silent NERDTreeMirror | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" [PLUGIN] Neomake
Plug 'neomake/neomake'

highlight NeomakeErrorSign ctermfg=196 ctermbg=235 guifg=#272822 guibg=#2D2E27
highlight NeomakeError cterm=underline ctermfg=196 guifg=#FF0000

" prioritize local .eslintrc file over global
let g:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe=substitute(g:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')

let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

"Execute Neomake only for some filetypes and after BufWrite event
autocmd! BufWritePost *.js,*.jsx,*.go Neomake

" [PLUGIN] EditorConfig
Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_max_line_indicator = 'exceeding'

" [PLUGIN]  GitGutter
Plug 'airblade/vim-gitgutter'

" [PLUGIN] fzf
" Needs silversearcher-ag package to grep into files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Command to generate tags file. Needs exuberant-ctags package
let g:fzf_tags_command = 'ctags -R'

" Obeying .*ignore files
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

function! s:escape(path)
    return substitute(a:path, ' ', '\\ ', 'g')
endfunction

function! AgHandler(line)
    let parts = split(a:line, ':')
    let [fn, lno] = parts[0 : 1]
    execute 'e '. s:escape(fn)
    execute lno
    normal! zz
endfunction

command! -nargs=+ Fag call fzf#run({
    \ 'source': 'ag "<args>"',
    \ 'sink': function('AgHandler'),
    \ 'options': '+m',
    \ 'tmux_height': '60%'})

" [PLUGIN] vim-devicons
Plug 'ryanoasis/vim-devicons'

" [PLUGIN] tmux-focus-event
Plug 'tmux-plugins/vim-tmux-focus-events'

" [PLUGIN] python-mode
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
let g:pymode_options_max_line_length = 100
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1

let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_autoimport = 1
let g:pymode_rope_autoimport_import_after_complete = 1

let g:pymode_lint_cwindow = 0
let g:pymode_lint_todo_symbol = '✔'
let g:pymode_lint_comment_symbol = '➤'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = '✖' "default: EE
let g:pymode_lint_info_symbol = 'ℹ' "default: II
let g:pymode_lint_pyflakes_symbol = '🐍' "default: FF

" [PLUGIN] black
Plug 'psf/black', { 'branch': 'stable' }

" run black when saving file
"autocmd BufWritePre *.py execute ':Black'

" End plugin manager section
call plug#end()
