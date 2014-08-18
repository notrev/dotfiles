" Source a global configuration file if available
" XXX Deprecated, please move your changes here in /etc/vim/vimrc
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" My Configurations
source ~/.vim/myconfs.vim

" Turning filetype detection off
" It will be turned on after all vundle plugins are loaded, to make sure
" that vim.less will be activated
filetype off

" Vundle
source ~/.vim/vundle.vim

" Turning filetype detection on
filetype on
