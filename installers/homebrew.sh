#!/bin/bash -e

#################
### Variables ###
#################

BREW_INSTALLER_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

########################
### Installation ###
########################

# Install homebrew
echo ""
echo "### Installing homebrew"
curl -fsSLo /tmp/brew-installer.sh $BREW_INSTALLER_URL
bash /tmp/brew-installer.sh

echo ""
echo "### Setting up brew in the environment"
if [[ -f $HOME/.zprofile ]] && [[ -z $(cat $HOME/.zprofile | grep "brew shellenv") ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Done!"