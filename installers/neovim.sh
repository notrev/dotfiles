#!/bin/bash -e

#################
### Variables ###
#################

VIM_UNDOFILES_DIR=$HOME/.vim-undo-files

########################
### Installation ###
########################

# Install neovim
echo ""
echo "### Installing neovim"
brew install neovim

# Install neovim's python 2 and 3 providers 
echo ""
echo "### Installing neovim's python3 providers"
python3 -m pip install neovim

echo ""
echo "### Installing neovim's node provider"
npm install -g neovim

# Create directories
echo ""
echo "### Creating directories"
mkdir -p $VIM_UNDOFILES_DIR

# Copy settings files
echo ""
echo "### Copying settings"
cp -r .config/nvim ~/.config/

echo ""
echo "### Installing plugin dependencies"
brew install fzf

# Start nvim to install plugins
echo ""
echo "### Starting nvim to install plugins"
nvim

echo "Done!"