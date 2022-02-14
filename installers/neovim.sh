#!/bin/bash -e

#################
### Variables ###
#################

# none

########################
### Installation ###
########################

# Install neovim
# echo ""
# echo "### Installing neovim"
# brew install neovim

# Install neovim's python 2 and 3 providers 
echo ""
echo "### Installing neovim's python3 providers"
python3 -m pip install neovim

echo ""
echo "### Installing neovim's node provider"
npm install -g neovim

echo "Done!"