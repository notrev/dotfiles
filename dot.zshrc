# =============
# Exports
# =============

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/notrev/.oh-my-zsh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# =============
# Aliases
# =============

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tmux="tmux -2"

# Open vim in read-only mode
alias view="vim -R"

# powerful less
export less='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

# =============
# less settings
# =============

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# =============
# Powerlevel9k
# =============

# Configurations
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="238"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="252"
POWERLEVEL9K_DIR_HOME_BACKGROUND=$POWERLEVEL9K_DIR_DEFAULT_BACKGROUND
POWERLEVEL9K_DIR_HOME_FOREGROUND=$POWERLEVEL9K_DIR_DEFAULT_FOREGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$POWERLEVEL9K_DIR_DEFAULT_BACKGROUND
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$POWERLEVEL9K_DIR_DEFAULT_FOREGROUND

POWERLEVEL9K_TIME_BACKGROUND="000"
POWERLEVEL9K_TIME_FOREGROUND="252"
POWERLEVEL9K_TIME_FORMAT="%D{\uF64F %H:%M:%S}"

POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
POWERLEVEL9K_VCS_GIT_ICON=""

POWERLEVEL9K_STATUS_OK_BACKGROUND="238"

POWERLEVEL9K_VIRTUALENV_BACKGROUND="148"
POWERLEVEL9K_VIRTUALENV_FOREGROUND="022"

POWERLEVEL9K_USER_DEFAULT_FOREGROUND="009"
POWERLEVEL9K_USER_ROOT_FOREGROUND="011"
POWERLEVEL9K_USER_ICON="%F{254}\uF007" # 
POWERLEVEL9K_ROOT_ICON="%F{254}\uF21B" # 

(( HOST_COLOR = (`hostname | wc -m`) % 15 )) # color according to hostname length
POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$HOST_COLOR"
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$HOST_COLOR"
POWERLEVEL9K_HOST_ICON="%F{254}\uF109" # 

POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{238}"

POWERLEVEL9K_CUSTOM_USER_INDICATOR="prompt_custom_user_indicator"

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
#POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{0}%F{252} \uf120 %k%F{0}%f" # 
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv user host dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status docker_machine aws time)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# =============
# Loading OMZ and custom segments
# =============

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Custom segments
source $HOME/.zsh.powerlevel9k-custom-segments

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
