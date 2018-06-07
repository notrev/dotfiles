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
#FONTCONFIG_DIR=$HOME/.config/fontconfig/conf.d/
NEOVIM_INSTALL_DIR=$HOME/.config/nvim
VIM_UNDOFILES_DIR=$HOME/.vim-undo-files

PPA_ROXTERM="ppa:h-realh/roxterm"
PPA_NEOVIM="ppa:neovim-ppa/unstable"

REPO_VUNDLE="http://github.com/VundleVim/Vundle.Vim"
REPO_POWERLEVEL9K="https://github.com/bhilburn/powerlevel9k.git"

OMZ_INSTALL_URL="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
FONT_MESLO_NERD="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/M/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.otf"

# Deb packages list
PKGS_LIST="build-essential \
            zsh \
            roxterm \
            neovim \
            git \
            tmux \
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

# Steps to setup Font with glyphs/icons
echo ""
echo "### Setting up fonts"
wget -c $FONT_MESLO_NERD \
    -P $FONTS_DIR/

fc-cache -vf $FONTS_DIR

# Steps to install ROXTerm
echo ""
echo "### Preparations for installing 'roxterm'"
sudo add-apt-repository $PPA_ROXTERM -y

# Steps to install NeoVIM
echo ""
echo "### Preparations for installing 'neovim'"
sudo add-apt-repository $PPA_NEOVIM -y

# Install Debian/Ubuntu packages
echo ""
echo "### Installing Debian packages with APT"
sudo apt-get update
sudo apt-get install $PKGS_LIST

# Set zsh as the main shell
chsh -s $(which zsh)

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
#echo ""
#echo "### Setting up GIT submodules"
#git submodule init
#git submodule update
#git submodule foreach git checkout master

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
#mkdir -p $FONTCONFIG_DIR
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
        git clone $REPO_VUNDLE Vundle.vim
    fi

    pushd $NEOVIM_INSTALL_DIR/bundle/Vundle.vim
        git checkout master
    popd
popd

echo ""
echo "### Installing NeoVIM plugins"
vim +PluginInstall +qall

# VIM - YouCompleteMe
echo ""
echo "### NeoVIM plugin installation: YouCompleteMe"
pushd $NEOVIM_INSTALL_DIR/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer --omnisharp-completer --tern-completer
popd

# Zsh - Install Oh-My-Zsh (https://github.com/robbyrussell/oh-my-zsh)
sh -c "$(curl -fsSL $OMZ_INSTALL_URL)"

# Zsh - powerlevel9k
git clone $REPO_POWERLEVEL9K $HOME/.oh-my-zsh/custom/themes/powerlevel9k
