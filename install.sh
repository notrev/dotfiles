#!/bin/bash -e

#################
### Variables ###
#################
FONTS_DIR=$HOME/.local/share/fonts/
FONTCONFIG_DIR=$HOME/.config/fontconfig/conf.d/
NEOVIM_INSTALL_DIR=$HOME/.config/nvim

VUNDLE_REPO="http://github.com/VundleVim/Vundle.Vim"

# Deb packages list
PKGS_LIST="build-essential \
            neovim \
            git \
            python-virtualenv \
            unzip \
            clang \
            nodejs \
            npm \
            cmake \
            python-dev \
            python-pip \
            python3-dev \
            python3-pip \
            mono-devel"

# NodeJS Packages:
#   - eslint : Used by VIM plugin for ECMAScript/Javascript syntax check
#   - babel-eslint : Required by 'eslint'
NODE_PKGS_LIST="eslint \
                babel-eslint"

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

# Steps to install NeoVIM
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Install Debian/Ubuntu packages
sudo apt-get update
sudo apt-get install $PKGS_LIST

# Set NeoVIM as alternative for VIM
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim

# Install NodeJS packages
sudo npm install -g $NODE_PKGS_LIST

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

# Download vundle - required to install VIM plugins
pushd $NEOVIM_INSTALL_DIR/bundle/
    git clone $VUNDLE_REPO vundle
    git checkout master
popd

vim +PluginInstall +qall

# VIM - Powerline fonts
cp $HOME/.vim/bundle/powerline/font/PowerlineSymbols.otf $FONTS_DIR
cp $HOME/.vim/bundle/powerline/font/10-powerline-symbols.conf $FONTCONFIG_DIR
etc/vim-powerline-fonts/install.sh

fc-cache -vf $FONTS_DIR

# VIM - YouCompleteMe
pushd $NEOVIM_INSTALL_DIR/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer --omnisharp-completer --tern-completer
popd
