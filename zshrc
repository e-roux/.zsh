# TODO: set those in ansible
# TODO: oc completion broken
#
# For docker-compose, see documentation
# https://docs.docker.com/compose/completion/
#
# curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose


# General {{{1
bindkey -v      # Use vi keybindings even if EDITOR is set to vi
export KEYTIMEOUT=20
bindkey -M viins 'jj' vi-cmd-mode ## bin 'jj' to cmd-mode

HISTSIZE=1000   # Shell history and file
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

HELPDIR=/usr/share/zsh/help

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space
setopt histignorealldups sharehistory

###########################################################################}}}1
# Plugins {{{1
###############################################################################
source $ZDOTDIR/utils.zsh

for plugin (
  $ZDOTDIR/opt/**/*.plugin.zsh(.)
  $ZDOTDIR/opt/spaceship-prompt/spaceship.zsh
  $HOME/.fzf.zsh
  $ZDOTDIR/opt/fzf/*.zsh(.)
  $HOME/.zsh/zshprivate
  ); [ -f $plugin ] && source $plugin

###########################################################################}}}1
# Completion {{{1
###############################################################################
# menu-select widget, part of the zsh/complist module
# must be loaded before the call to compinit
zmodload -i zsh/complist
# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# Tell zsh which function to use for completing a command
fpath=(~/.zsh/completion $fpath)
# Use modern completion system
autoload -Uz compinit
compinit

# From https://grml.org/zsh/zsh-lovers.html
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages) Use a cache:
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case insensitive match
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# -----------------------------------------------------------------------------
# SSH {{{2
# -----------------------------------------------------------------------------
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
# if [[ -r ~/.ssh/known_hosts ]]; then
#   h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
# fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:scp:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi
# }}}2
###########################################################################}}}1
# Aliases {{{1
###############################################################################

# LS
alias ls='ls -F --color=always --group-directories-first'
alias ll='ls -la'
alias lh='ll -h'
alias ld='ls -d */'
alias la='ls -CA'

alias f=fzf
alias fb='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'

[ -x "$(which bat)" ] && alias cat=bat
alias d=docker
alias exa='exa -hTlL 1 --git --group-directories-first'
alias l='exa'
[ -x "$(which fdfinf)" ] && alias fd=fdfind
alias g=git
alias gg=googler
alias help=run-help
alias pc=pre-commit
[ -x /usr/bin/VBoxManage ] && alias vbm=VBoxManage
alias yg=you-get

[ -x "$(which kubectl)" ] && alias k=kubectl && source <(kubectl completion zsh)
[ -x "$(which oc)" ] && source <(oc completion zsh)
[ -x "$(which helm)" ] && source <(helm completion zsh)
#
# From https://kubernetes.io/docs/reference/kubectl/cheatsheet/
# [ -x "$(which kubectl)" ] && complete -F __start_kubectl k

# alias -s {txt,py,conf,pl,yml,yaml}=vim
############################################################################}}}1

# eval "$(pyenv init zsh -)"
#
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
_conda=$(pyenv which conda)
__conda_setup="$('conda' 'shell.zsh' 'hook' 2> /dev/null)"
__conda_bin=$(pyenv which conda)
__conda_path=$(dirname "${__conda_bin}")
# alias conda="CONDA_EXE=$(pyenv which conda)  CONDA_CHANGEPS1=False PATH=\"$(dirname $(dirname $(pyenv which conda)))/condabin:$(dirname $(pyenv which conda)):$PATH\" $(pyenv which conda)"
# eval "$__conda_setup"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/manu/.opt/pyenv/versions/miniconda3-4.7.12/etc/profile.d/conda.sh" ]; then
#         . /home/manu/.opt/pyenv/versions/miniconda3-4.7.12/etc/profile.d/conda.sh
#     else
#         export PATH="/home/manu/.opt/pyenv/versions/miniconda3-4.7.12/bin:$PATH"
#     fi
# fi
unset __conda_setup
# <<< conda initialize <<<


# alternative to zshz for test
# TODO: test zoxide
[ -x "$(which jump)" ] && eval "$(jump shell zsh)"

# Theme {{{1
# If theme pure is installed, activate
# pure seems faster than a lot of other
# theme providing git integration
# -> asynchronous calls
if [ -d $ZDOTDIR/opt/pure ]
then
  fpath+=$ZDOTDIR/opt/pure

  autoload -U promptinit; promptinit
  PURE_CMD_MAX_EXEC_TIME=10
  zstyle ':prompt:pure:prompt:*' color cyan
  zstyle :prompt:pure:git:stash show yes
  zstyle :prompt:pure:git:dirty color magenta
  zstyle ':prompt:pure:git:*' color green
  zstyle :prompt:pure:virtualenv color yellow
  prompt pure
fi
###########################################################################}}}1
# vim:fdm=marker
