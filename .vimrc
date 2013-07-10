" Source a global configuration file if available
" XXX Deprecated, please move your changes here in /etc/vim/vimrc
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" My Configurations
source ~/.vim/myconfs.vim

" Vundle
source ~/.vim/vundle.vim
