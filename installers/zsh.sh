#!/bin/bash -e

#################
### Variables ###
#################

OMZ_INSTALLER="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
P10K_REPO="https://github.com/romkatv/powerlevel10k.git"

####################
### Installation ###
####################

# Install zplugin
# echo ""
# echo "### Installing Oh-My-Zsh"
# curl -fsSLo /tmp/omz-installer.sh $OMZ_INSTALLER
# bash /tmp/omz-installer.sh

echo ""
echo "### Installing powerlevel10k"
git clone --depth=1 $P10K_REPO ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k