# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#-----------------------
# COLORS
#
# Background color: #353535
# Intense Background color: #3E3E3E
#-----------------------
BLACK="\[\033[0;30m\]"              #4A4948
RED="\[\033[0;31m\]"                #C05350
GREEN="\[\033[0;32m\]"              #729533
YELLOW="\[\033[0;33m\]"             #BA8A33
BLUE="\[\033[0;34m\]"               #4B8CBA
MAGENTA="\[\033[0;35m\]"            #BA5586
CYAN="\[\033[0;36m\]"               #4D9994
GRAY="\[\033[0;37m\]"               #CBC7BB
DARK_GRAY="\[\033[1;30m\]"          #73716C
LIGHT_RED="\[\033[1;31m\]"          #E95C59
LIGHT_GREEN="\[\033[1;32m\]"        #8CBE33
LIGHT_YELLOW="\[\033[1;33m\]"       #E5AB41
LIGHT_BLUE="\[\033[1;34m\]"         #52A6E3
LIGHT_MAGENTA="\[\033[1;35m\]"      #D65E97
LIGHT_CYAN="\[\033[1;36m\]"         #58E2BA
LIGHT_GRAY="\[\033[1;37m\]"         #F4EFDF
COLOR_NONE="\[\e[0m\]"
COLOR_DEFAULT="\[\033[00m\]"

#-----------------------
# FUNCTIONS
#-----------------------
# Function that generates a color to hostname according to the size of its name
function set_hostname_color() {
    WC=$(echo "$HOSTNAME" | wc -c)
    COLOR_VALUE=$(( ($WC % 7) + 30 ))
    HOSTNAME_COLOR="\[\033[0;"$COLOR_VALUE"m\]"
}

# VirtualEnv indicator
function set_py_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        PY_VIRTUALENV="<$(basename "$VIRTUAL_ENV")> "
    else
        unset PY_VIRTUALENV
    fi
}

# GIT branch
function set_git_branch() {
    GIT_BRANCH=$(__git_ps1 " [%s]")
}

# Set user level indicator. $ for normal user, or # for root
function set_userlevel_indicator() {
    if [ $EUID -ne 0 ]; then
        USER_INDICATOR='$';
        USER_COLOR=$LIGHT_RED;
    else
        USER_INDICATOR='#';
        USER_COLOR=$LIGHT_YELLOW;
    fi
}

function setup_color_prompt() {
    PS1="${debian_chroot:+($debian_chroot)}"
    PS1="${PS1}${DARK_GRAY}${PY_VIRTUALENV}"                                                # VirtualEnv
    PS1="${PS1}${USER_COLOR}\u${LIGHT_GRAY}@${HOSTNAME_COLOR}\h${LIGHT_GRAY}:${GREEN}\w"    # u@h:w
    PS1="${PS1}${DARK_GRAY}${GIT_BRANCH} "                                                  # Git Branch
    PS1="${PS1}${COLOR_DEFAULT}${USER_INDICATOR} "
}

function setup_prompt() {
    PS1="${debian_chroot:+($debian_chroot)}"
    PS1="${PS1}${PY_VIRTUALENV}"            # VirtualEnv
    PS1="${PS1}\u@\h:\w"                    # u@h:w
    PS1="${PS1}${GIT_BRANCH} "              # Git Branch
    PS1="${PS1}${USER_INDICATOR} "
}

function prompt_command() {
    # Append command to history as soon as it is executed
    history -a
    history -n

    set_userlevel_indicator
    set_hostname_color
    set_git_branch
    set_py_virtualenv

    setup_color_prompt
}


#-----------------------
# SETTINGS
#-----------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# If there is a .git-prompt file, load it.
[ -f $HOME/.git-prompt.sh ] && source $HOME/.git-prompt.sh

# Command executed everytime the prompt is displayed
PROMPT_COMMAND=prompt_command

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## uncomment for a colored prompt, if the terminal has the capability; turned
## off by default to not distract the user: the focus in a terminal window
## should be on the output of commands, not on the prompt
#force_color_prompt=yes
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#        # We have color support; assume it's compliant with Ecma-48
#        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#        # a case would tend to support setf rather than setaf.)
#        color_prompt=yes
#    else
#        color_prompt=
#    fi
#fi
#
#if [ "$color_prompt" = yes ]; then
#    setup_color_prompt
#else
#    setup_prompt
#fi
#
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1";;
    *) ;;
esac

# enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# My Bin
if [ -d $HOME/.local/bin ]; then
    PATH=$HOME/.local/bin:$PATH
fi

# ICECC
if [ -d /usr/lib/icecc/bin ]; then
    ICECC_VERSION=$HOME/.icecc/.icecream.tar.gz
    PATH=/usr/lib/icecc/bin:$PATH
    alias make='CC="icecc" make'
fi

# Android NDK
if [ -d /opt/android-ndk-r8b ] ; then
    PATH=/opt/android-ndk-r8b:$PATH
fi

# Android SDK
if [ -d /opt/android-sdk ] ; then
    PATH=/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH
elif [ -d /Applications/Android-SDK ]; then
    PATH=/Applications/Android-SDK/platform-tools:/Applications/Android-SDK/tools:$PATH
fi

# Tizen SDK CLI
if [ -d $HOME/tizen-sdk ] ; then
    PATH=$HOME/tizen-sdk/tools/:$PATH
    PATH=$HOME/tizen-sdk/tools/emulator/bin:$PATH
    PATH=$HOME/tizen-sdk/tools/ide/bin:$PATH
fi

# Git
if [ -d /opt/git ] ; then
    PATH=/opt/git/bin:$PATH
    LD_LIBRARY_PATH=/opt/git/lib:$LD_LIBRARY_PATH
fi

if [ -f $HOME/.git-completion.bash ]; then
    . $HOME/.git-completion.bash
fi

# Node.JS
NODEJS_VERSION="0.10.31"
if [ -d "/opt/nodejs-$NODEJS_VERSION" ] ; then
    PATH=/opt/nodejs-$NODEJS_VERSION/bin:$PATH
    LD_LIBRARY_PATH=/opt/nodejs-$NODEJS_VERSION/lib:$LD_LIBRARY_PATH
fi

# P4 - perforce
if [ -f $HOME/.p4settings ]; then
    P4CONFIG=$HOME/.p4settings
fi

if [ -f $HOME/p4v-env ]; then
    . $HOME/p4v-env
fi

# Enable programmable sdb completion features.
if [ -f $HOME/.sdb/.sdb-completion.bash ]; then
    . $HOME/.sdb/.sdb-completion.bash
fi

# Mac OS X specific settings
if [ "$(uname -s)" == "Darwin" ]; then
    if [ -f $HOME/.bash_macosx ]; then
        . $HOME/.bash_macosx
    fi
fi

#Proxy
#export http_proxy="http://105.103.141.69:3128"
#export https_proxy="http://105.103.141.69:3128"
