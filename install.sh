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
TMUX_DIR=$HOME/.tmux

PPA_ROXTERM="ppa:h-realh/roxterm"
PPA_NEOVIM="ppa:neovim-ppa/unstable"

REPO_ROXTERM_DISCO="deb http://ppa.launchpad.net/h-realh/roxterm/ubuntu disco main"
REPO_POWERLEVEL10K="https://github.com/romkatv/powerlevel10k.git"
REPO_TMUX_PLUGIN_MANAGER="https://github.com/tmux-plugins/tpm"

VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
NVM_INSTALL_URL="https://raw.githubusercontent.com/creationix/nvm/master/install.sh"
OMZ_INSTALL_URL="https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
FONT_MESLO_NERD="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo/M/Regular/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.ttf?raw=true"

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
            golang-go \
            python-dev \
            python-pip \
            python3-dev \
            python3-pip \
            mono-devel \
            editorconfig \
            silversearcher-ag \
            urlview"

# NodeJS Packages:
#   - eslint : Used by VIM plugin for ECMAScript/Javascript syntax check
#   - babel-eslint : Required by 'eslint'
NODE_PKGS_LIST="eslint \
                babel-eslint \
                typescript"

########################
### Install packages ###
########################

# Steps to install mono-devel
# Mono is required to install Omnisharp, which is used in VIM's YouCompleteMe
echo ""
echo "### Preparations for installing 'mono-devel'"
if [ ! -f /etc/apt/sources.list.d/mono-xamarin.list ]; then
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
sudo add-apt-repository $PPA_ROXTERM -y || PPA_ROXTERM_FAIL=1
[[ $PPA_ROXTERM_FAIL == 1 ]] && sudo rm /etc/apt/sources.list.d/h-realh-ubuntu-roxterm-eoan.list* \
    && echo "$REPO_ROXTERM_DISCO" | sudo tee /etc/apt/sources.list.d/roxterm-disco.list

# Steps to install NeoVIM
echo ""
echo "### Preparations for installing 'neovim'"
sudo add-apt-repository $PPA_NEOVIM -y

# Install Debian/Ubuntu packages
echo ""
echo "### Installing Debian packages with APT"
sudo apt-get update
sudo apt-get install $PKGS_LIST -y

# Set zsh as the main shell
chsh -s $(which zsh)

# Set NeoVIM as alternative for VIM
echo ""
echo "### Updating alternatives: vim -> nvim"
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim

# Install NVM (NodeJS Version Manager)
echo ""
echo "### Installing NVM"
wget -qO- $NVM_INSTALL_URL | zsh

# Export NVM to $PATH and load it
echo ""
echo "### Loading NVM"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Latest LTS versions of NodeJS and NPM
echo ""
echo "### Installing latest LTS versions of NodeJS and NPM"
nvm install --lts --latest-npm

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
DOT_FILES=$(ls -d dot.*)

mkdir -p /tmp/home
for FILE in $DOT_FILES; do
    # Remove 'dot' prefix
    echo "cp $FILE /tmp/home"
    FILE_NO_PREFIX=$(echo $FILE | sed -e 's;^dot;;')
    cp -r $FILE /tmp/home/$FILE_NO_PREFIX
done

cp -rT /tmp/home $HOME
rm -rf /tmp/home

##########################
### Create directories ###
##########################
echo ""
echo "### Creating directories"
mkdir -p $FONTS_DIR
#mkdir -p $FONTCONFIG_DIR
mkdir -p $VIM_UNDOFILES_DIR
mkdir -p $TMUX_DIR
mkdir -p $NEOVIM_INSTALL_DIR/autoload

########################################
### Configure and Install submodules ###
########################################
echo ""
echo "### Preparations for installing NeoVIM plugins"
pip2 install --upgrade neovim
pip3 install --upgrade neovim

echo ""
echo "### Installing vim-plug and NeoVIM plugins"
wget -O $NEOVIM_INSTALL_DIR/autoload/plug.vim $VIM_PLUG_URL
vim +PlugInstall +qall

# Zsh - Install Oh-My-Zsh (https://github.com/robbyrussell/oh-my-zsh)
echo ""
echo "### Installing Oh-My-Zsh"
sh -c "$(wget $OMZ_INSTALL_URL -O - | sed '/\s*env\s\s*zsh\s*/d')"

# Zsh - powerlevel9k
echo ""
echo "### Oh-My-Zsh theme installation: POWERLEVEL10K"
git clone --depth=1 $REPO_POWERLEVEL10K ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Zsh - Copying Zsh dot-files to overwrite them if they were modified
echo ""
echo "### Copying Zsh dot-files"
DOT_FILES=$(ls -d dot.zsh*)

for FILE in $DOT_FILES; do
    # Remove 'dot' prefix
    FILE_NO_PREFIX=$(echo $FILE | sed -e 's;^dot;;')
    cp -r $FILE $HOME/$FILE_NO_PREFIX
done

# tmux - Install powerline for tmux
echo ""
echo "### Installing powerline for tmux"
pip3 install powerline-status

# tmux - tmux plugin manager
echo ""
echo "### Cloning tmux plugin manager"
git clone $REPO_TMUX_PLUGIN_MANAGER $TMUX_DIR/plugins/tpm

echo ""
echo "### Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
