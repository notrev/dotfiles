# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#-----------------------
# COLORS
#-----------------------
PSX_ZONE_SEPARATOR=""
PSX_ZONE_SEPARATOR_FULL=""
PSX_GIT_BRANCH_ICON=""
PSX_DEFAULT_FG="\[\e[38;5;255m\]"       # white
PSX_ZONE1_FG="\[\e[38;5;22m\]"          # darker green
PSX_ZONE1_BG="\[\e[48;5;148m\]"         # green
PSX_ZONE1_BG_AS_FG="\[\e[38;5;148m\]"   # green
PSX_ZONE2_FG=$PSX_DEFAULT_FG
PSX_ZONE2_BG="\[\e[48;5;240m\]"         # dark gray
PSX_ZONE2_BG_AS_FG="\[\e[38;5;240m\]"   # dark gray
PSX_ZONE3_FG=$PSX_DEFAULT_FG
PSX_ZONE3_BG="\[\e[48;5;236m\]"         # light gray
PSX_ZONE3_BG_AS_FG="\[\e[38;5;236m\]"   # light gray
PSX_ZONE4_FG="\[\e[38;5;124m\]"         # darker orange
PSX_ZONE4_BG="\[\e[48;5;208m\]"         # orange
PSX_ZONE4_BG_AS_FG="\[\e[38;5;208m\]"   # orange
PSX_COLOR_CLEAR="\[\e[0m\]"
PSX_USERNAME_COLOR="\[\e[38;5;148m\]"   # green
PSX_ROOTUSER_COLOR="\[\e[38;5;11m\]"    # yellow
PSX_HOSTNAME_COLORS=(
    \ "\[\e[38;5;1m\]"
    \ "\[\e[38;5;2m\]"
    \ "\[\e[38;5;3m\]"
    \ "\[\e[38;5;4m\]"
    \ "\[\e[38;5;5m\]"
    \ "\[\e[38;5;6m\]"
    \ "\[\e[38;5;7m\]"
    \ "\[\e[38;5;8m\]"
    \ "\[\e[38;5;9m\]"
    \ "\[\e[38;5;10m\]"
    \ "\[\e[38;5;11m\]"
    \ "\[\e[38;5;12m\]"
    \ "\[\e[38;5;13m\]"
    \ "\[\e[38;5;14m\]"
    \ "\[\e[38;5;15m\]" )


#-----------------------
# FUNCTIONS
#-----------------------
# Function that generates a color to hostname according to the size of its name
function set_hostname_color() {
    WC=$(echo "$HOSTNAME" | wc -c)
    INDEX=$(( $WC % ${#PSX_HOSTNAME_COLORS[@]} ))
    HOSTNAME_COLOR=${PSX_HOSTNAME_COLORS[INDEX]}
}

# VirtualEnv indicator
function set_py_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        PY_VIRTUALENV="$(basename "$VIRTUAL_ENV")"
    else
        unset PY_VIRTUALENV
    fi
}

# GIT branch
function set_git_branch() {
    GIT_BRANCH=$(__git_ps1 "${PSX_GIT_BRANCH_ICON} %s")
}

# Set user level indicator. $ for normal user, or # for root
function set_userlevel_indicator() {
    if [ $EUID -ne 0 ]; then
        USER_INDICATOR='$';
        USER_COLOR=$PSX_USERNAME_COLOR;
    else
        USER_INDICATOR='#';
        USER_COLOR=$PSX_ROOTUSER_COLOR;
    fi
}

function setup_color_prompt() {
    PS1="\n${debian_chroot:+($debian_chroot)}"

    if [ -n "$PY_VIRTUALENV" ]; then
        PS1="${PS1}${PSX_ZONE1_BG}${PSX_ZONE1_FG} ${PY_VIRTUALENV} "
        PS1="${PS1}${PSX_ZONE2_BG}${PSX_ZONE1_BG_AS_FG}${PSX_ZONE_SEPARATOR_FULL}"
    fi

    PS1="${PS1}${PSX_ZONE2_BG} ${USER_COLOR}\u${PSX_DEFAULT_FG} @${HOSTNAME_COLOR}\h "
    PS1="${PS1}${PSX_ZONE3_BG}${PSX_ZONE2_BG_AS_FG}${PSX_ZONE_SEPARATOR_FULL}"
    PS1="${PS1}${PSX_ZONE3_FG} \w "

    if [ "$GIT_BRANCH" != "" ]; then
        PS1="${PS1}${PSX_ZONE4_BG}${PSX_ZONE3_BG_AS_FG}${PSX_ZONE_SEPARATOR_FULL}"
        PS1="${PS1}${PSX_ZONE4_FG} ${GIT_BRANCH} "
        PS1="${PS1}${PSX_COLOR_CLEAR}${PSX_ZONE4_BG_AS_FG}${PSX_ZONE_SEPARATOR_FULL}${PSX_COLOR_CLEAR}\n"
    else
        PS1="${PS1}${PSX_COLOR_CLEAR}${PSX_ZONE3_BG_AS_FG}${PSX_ZONE_SEPARATOR_FULL}${PSX_COLOR_CLEAR}\n"
    fi

    PS1="${PS1}${USER_COLOR} ${USER_INDICATOR} ${PSX_DEFAULT_FG}${PSX_ZONE_SEPARATOR} "
    PS1="${PS1}${PSX_COLOR_CLEAR}"
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

# Android NDK
if [ -d /opt/android/ndk-r8b ] ; then
    PATH=/opt/android/ndk-r8b:$PATH
fi

# Android SDK
if [ -d /opt/android/sdk ] ; then
    PATH=/opt/android/sdk/platform-tools:$PATH
    PATH=/opt/android/sdk/tools:$PATH
elif [ -d /Applications/Android-SDK ]; then
    PATH=/Applications/Android-SDK/platform-tools:$PATH
    PATH=/Applications/Android-SDK/tools:$PATH
fi

# Android Studio
if [ -d /opt/android/studio ] ; then
    PATH=/opt/android/studio/bin:$PATH
    PATH=/opt/android/studio/gradle/gradle-2.14.1/bin:$PATH
fi

# Git
if [ -d /opt/git ] ; then
    PATH=/opt/git/bin:$PATH
    LD_LIBRARY_PATH=/opt/git/lib:$LD_LIBRARY_PATH
fi

if [ -f $HOME/.git-completion.bash ]; then
    . $HOME/.git-completion.bash
fi

# Mac OS X specific settings
if [ "$(uname -s)" == "Darwin" ]; then
    if [ -f $HOME/.bash_macosx ]; then
        . $HOME/.bash_macosx
    fi
fi

# $HOME based prefix for global node_modules
export PATH=$HOME/.npm-pkgs/bin:$PATH
export NODE_PATH=$HOME/.npm-pkgs/lib/node_modules:$NODE_PATH

#Proxy
#export http_proxy="http://105.103.141.69:3128"
#export https_proxy="http://105.103.141.69:3128"
