# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#-----------------------
# FUNCTIONS
#-----------------------
# Function that generates a color to hostname according to itself
function hostnameColor() {
    WC=`echo "$HOSTNAME" | wc -c`
    COLOR_VALUE=$(( ($WC % 7) + 30 ))
    echo "\[\033[0;"$COLOR_VALUE"m\]"
}

# VirtualEnv indicator
# TODO: This indicator is not being shown the way it should
function py_virtualenv() {
    if test -z "$VIRTUAL_ENV"; then
        echo ""
    else
        echo "[`basename \"$VIRTUAL_ENV\"`] "
    fi
}

# GIT branch
function git_branch() {
    echo '$(__git_ps1 " [%s]")'
}

#-----------------------
# COLORS
#-----------------------
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BROWN="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
LIGHT_GRAY="\[\033[0;37m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[1;33m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_CYAN="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"
COLOR_NONE="\[\e[0m\]"
COLOR_DEFAULT="\[\033[00m\]"

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

# Append command to history as soon as it is executed
PROMPT_COMMAND='history -a ; history -n'

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

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # get hostname color
    HC=$(hostnameColor)

    PS1="${debian_chroot:+($debian_chroot)}"
    PS1="${PS1}${GREEN}$(py_virtualenv)"                            # VirtualEnv
    PS1="${PS1}${LIGHT_RED}\u${WHITE}@${HC}\h${PS1}${WHITE}:${YELLOW}\w" # u@h:w
    PS1="${PS1}${DARK_GRAY}$(git_branch) ${COLOR_DEFAULT}\$ "       # Git Branch

    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;30m\]$(__git_ps1 " [%s]") \[\033[00m\]\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1="${debian_chroot:+($debian_chroot)}"
    PS1="${PS1}$(py_virtualenv)"            # VirtualEnv
    PS1="${PS1}\u@\h:\w"                    # u@h:w
    PS1="${PS1}$(git_branch) \$ "           # Git Branch

    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

# ICECC
if [ -d /usr/lib/icecc/bin ]; then
    export ICECC_VERSION=$HOME/.icecc/.icecream.tar.gz
    export PATH=/usr/lib/icecc/bin:$PATH
    alias make='CC="icecc" make'
fi

# Android NDK
if [ -d /opt/android-ndk-r8b ] ; then
    PATH=/opt/android-ndk-r8b:$PATH
fi

# Android SDK
if [ -d /opt/android-sdk ] ; then
   PATH=/opt/android-sdk/platform-tools:/opt/android-sdk/tools:$PATH
fi

# Tizen SDK CLI
if [ -d $HOME/.tizen/tizen-sdk ] ; then
   PATH=$HOME/.tizen/tizen-sdk/tools/:$PATH
   PATH=$HOME/.tizen/tizen-sdk/tools/ide/bin:$PATH
fi

# Git
if [ -d /opt/git ] ; then
   PATH=/opt/git/bin:$PATH
   LD_LIBRARY_PATH=/opt/git/lib:$LD_LIBRARY_PATH
fi

# P4 - perforce
export P4CONFIG=$HOME/.p4settings
source $HOME/p4v-env
