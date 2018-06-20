# DOTFILES
Author: Éverton Arruda | http://earruda.eti.br

These are my linux dotfiles, with all my preffered configurations.

It contains configurations for:
* GIT
* NeoVIM
* Zsh + Oh-My-Zsh + Powerlevel9k theme
* ROXterm
* tmux

## Installation
The installation script was only tested in Ubuntu GNU/Linux.

### Dependencies
To run the installation script correctly you will need the following commands:
* `sudo` - available in the package **sudo**
* `wget` - available in the package **wget**
* `add-apt-repository` - available in the package **software-properties-common**
* `fc-cache` - available in the pacakge **fontconfig**

### Running the installation script
If the `install.sh` script is an executable (+x), you can run:

```
    $ ./install.sh
```

if it is not an executable, you can run:

```
    $ bash -e install.sh
```

With the `-e` parameter, `bash` stops the execution if any error occurs

## Other information
Font used in terminal: Meslo LG M Regular Nerd Font Complete (https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo/M/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.otf)
