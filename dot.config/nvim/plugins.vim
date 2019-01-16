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
    if &filetype == "help"
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
    if &filetype == "help"
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
    return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
            \ ('' != expand('%f') ? fnamemodify(expand("%"), ":~:."): '[No Name]') .
            \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineMode()
    return lightline#mode()[0]
    " return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' .
         \ WebDevIconsGetFileTypeSymbol() : '') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" [PLUGIN] YouCompleteMe - Code autocompletion
Plug 'Valloric/YouCompleteMe', { 'do': 'rm third_party/ycmd/third_party/tern_runtime/node_modules ; python3 install.py --all' }

" Javascript GoTo keymapping
autocmd FileType javascript nmap <buffer> <C-]> :YcmCompleter GoTo<CR>

" [PLUGIN] Emmet - HTML expansion
Plug 'mattn/emmet-vim', { 'for': 'html' }

" [PLUGIN] VIM-Polyglot
Plug 'sheerun/vim-polyglot'

let g:javascript_plugin_jsdoc = 1

" [PLUGIN] NERDTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

map ,n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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

" End plugin manager section
call plug#end()
