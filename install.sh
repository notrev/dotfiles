#!/bin/bash -e

#################
### Variables ###
#################
FONTS_DIR=$HOME/.local/share/fonts/
FONTCONFIG_DIR=$HOME/.config/fontconfig/conf.d/

# Deb packages list
PKGS_LIST=" build-essential \
            vim \
            vim-nox-py2 \
            git \
            python-virtualenv \
            unzip \
            clang \
            nodejs \
            cmake \
            python-dev \
            mono-devel"

########################
### Install packages ###
########################

# Steps to install mono-devel
# Mono is required to install Omnisharp, which is used in VIM's YouCompleteMe
if [ ! -f /etc/apt/sources.list.d/mono-xamarin.list ]
then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                     --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

    echo "deb http://download.mono-project.com/repo/debian wheezy main" | \
        sudo tee /etc/apt/sources.list.d/mono-xamarin.list
fi

sudo apt-get update
sudo apt-get install $PKGS_LIST

###########################
### Initiate submodules ###
###########################
git submodule init
git submodule foreach git checkout master

# For update
#git submodules update

###############################
### Copy dot-files to $HOME ###
###############################
DOT_FILES=$(ls -a --ignore={.,..,README*,LICENSE*,install.sh*,.git*,etc})

for FILE in $DOT_FILES
do
    cp -r $FILE $HOME
done

##########################
### Create directories ###
##########################
mkdir $FONTS_DIR
mkdir -p $FONTCONFIG_DIR

########################################
### Configure and Install submodules ###
########################################
# VIM - Powerline fonts
cp $HOME/.vim/bundle/powerline/font/PowerlineSymbols.otf $FONTS_DIR
cp $HOME/.vim/bundle/powerline/font/10-powerline-symbols.conf $FONTCONFIG_DIR
etc/vim-powerline-fonts/install.sh

fc-cache -vf $FONTS_DIR

vim +PluginInstall +qall

# VIM - YouCompleteMe
pushd $HOME/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer --omnisharp-completer
popd
