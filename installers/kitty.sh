#!/bin/bash -e

# This installation script requires some commands that might not be in a minimal
# environment.
#   - git

#################
### Variables ###
#################

PKG_KITTY="kitty"
REPO_KITTY_THEMES="https://github.com/dexpota/kitty-themes.git"
DOT_FILES_ORIGIN="dot.config/kitty"
DOT_FILES_DESTINATION="$HOME/.config/"

########################
### Install packages ###
########################

# Install packages
echo ""
echo "### Installing kitty packages with APT"
sudo apt-get update
sudo apt-get install $PKG_KITTY -y

###############################
### Copy dot-files to $HOME ###
###############################

echo ""
echo "### Copying dot-files to home directory"
mkdir -p $DOT_FILES_DESTINATION
cp -r $DOT_FILES_ORIGIN $DOT_FILES_DESTINATION

############################
### Install Kitty themes ###
############################

git clone $REPO_KITTY_THEMES $DOT_FILES_DESTINATION/kitty/themes
