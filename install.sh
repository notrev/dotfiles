#!/bin/bash -e

# This installation script requires some commands that might not be in a minimal
# environment.
#   - wget : in package wget
#   - add-apt-repository : in package software-properties-common
#   - fc-cache : in package fontconfig

#################
### Variables ###
#################
FONTS_DIR=$HOME/.local/share/fonts/
FONTCONFIG_DIR=$HOME/.config/fontconfig/conf.d/
NEOVIM_INSTALL_DIR=$HOME/.config/nvim
VIM_UNDOFILES_DIR=$HOME/.vim-undo-files

VUNDLE_REPO="http://github.com/VundleVim/Vundle.Vim"

# Deb packages list
PKGS_LIST="build-essential \
            neovim \
            git \
            python-virtualenv \
            unzip \
            clang \
            nodejs \
            nodejs-legacy \
            npm \
            cmake \
            python-dev \
            python-pip \
            python3-dev \
            python3-pip \
            mono-devel \
            editorconfig"

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
echo ""
echo "### Preparations for installing 'mono-devel'"
if [ ! -f /etc/apt/sources.list.d/mono-xamarin.list ]
then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                     --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

    echo "deb http://download.mono-project.com/repo/debian wheezy main" | \
        sudo tee /etc/apt/sources.list.d/mono-xamarin.list
fi

# Steps to install NeoVIM
echo ""
echo "### Preparations for installing 'neovim'"
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Install Debian/Ubuntu packages
echo ""
echo "### Installing Debian packages with APT"
sudo apt-get update
sudo apt-get install $PKGS_LIST

# Set NeoVIM as alternative for VIM
echo ""
echo "### Updating alternatives: vim -> nvim"
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim

# Install NodeJS packages
echo ""
echo "### Installing NodeJS packages with NPM"
sudo npm install -g $NODE_PKGS_LIST

###########################
### Initiate submodules ###
###########################
echo ""
echo "### Setting up GIT submodules"
git submodule init
git submodule update
git submodule foreach git checkout master

###############################
### Copy dot-files to $HOME ###
###############################
echo ""
echo "### Copying dot-files to home directory"
DOT_FILES=$(ls -a --ignore={.,..,README*,LICENSE*,install.sh*,.git*,etc})

for FILE in $DOT_FILES
do
    cp -r $FILE $HOME
done

##########################
### Create directories ###
##########################
echo ""
echo "### Creating directories"
mkdir -p $FONTS_DIR
mkdir -p $FONTCONFIG_DIR
mkdir -p $VIM_UNDOFILES_DIR

########################################
### Configure and Install submodules ###
########################################

# Download vundle - required to install VIM plugins
echo ""
echo "### Preparations for installing NeoVIM plugins"

pip install --upgrade neovim
pip2 install --upgrade neovim
pip3 install --upgrade neovim

pushd $NEOVIM_INSTALL_DIR/bundle/
    if [ ! -d Vundle.vim ]; then
        git clone $VUNDLE_REPO Vundle.vim
    fi

    pushd $NEOVIM_INSTALL_DIR/bundle/Vundle.vim
        git checkout master
    popd
popd

echo ""
echo "### Installing NeoVIM plugins"
vim +PluginInstall +qall

# VIM - Powerline fonts
echo ""
echo "### Setting up fonts"
wget -c https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf \
    -O $FONTS_DIR/PowerlineSymbols.otf
wget -c https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf \
    -O $FONTCONFIG_DIR/10-powerline-symbols.conf

etc/vim-powerline-fonts/install.sh

fc-cache -vf $FONTS_DIR

# VIM - YouCompleteMe
echo ""
echo "### NeoVIM plugin installation: YouCompleteMe"
pushd $NEOVIM_INSTALL_DIR/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer --omnisharp-completer --tern-completer
popd
