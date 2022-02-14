#!/bin/bash -e

#################
### Variables ###
#################

NVM_INSTALLER_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh"

########################
### Installation ###
########################

Install Node Version Manager
echo ""
echo "### Installing homebrew"
curl -fsSLo /tmp/nvm-installer.sh $NVM_INSTALLER_URL
bash /tmp/nvm-installer.sh

# Install latest Node version
echo ""
echo "### Installing latest node version"
NVM_DIR=$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

echo "Done!"