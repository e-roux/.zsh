# General {{{1
# Use vi keybindings even if EDITOR is set to vi
bindkey -v

# Shell history and file
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

# Remove command lines from the history list when the first character on the
# # line is a space, or when one of the expanded aliases contains a leading space
setopt histignorealldups sharehistory

zmodload -i zsh/complist
# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# Tell zsh which function to use for completing a command
fpath=(~/.zsh/completion $fpath)
# Use modern completion system
autoload -Uz compinit
compinit

###########################################################################}}}1

# https://github.com/denysdovhan/spaceship-prompt
export SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  golang        # Go section
  docker        # Docker section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  kubectl       # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  vi_mode       # Vi-mode indicator
)

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

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

###############################################################################
# COMPLETION {{{1
###############################################################################
[ -x "$(which kubectl)" ] && source <(kubectl completion zsh)
[ -x "$(which oc)" ] && source <(oc completion zsh)
[ -x "$(which helm)" ] && source <(helm completion zsh)

# For docker-compose, see documentation
# https://docs.docker.com/compose/completion/
#
# curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

###########################################################################}}}1
# ALIASES {{{1
###############################################################################
[ -x /usr/bin/fdfind ] && alias fd=fdfind

# LS
alias ls='ls -F --color=always --group-directories-first'
alias ll='ls -la'
alias lh='ll -h'
alias ld='ls -d */'
alias la='ls -CA'
alias l='ls'

alias f=fzf
alias fb=fzf --preview '[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (bat --style=numbers --color=always {} ||
                  highlight -O ansi -l {} ||
                  coderay {} ||
                  rougify {} ||
                  cat {}) 2> /dev/null | head -500'
                  #
alias cat=bat
alias exa='exa -hTlL 1 --git --group-directories-first'
alias g=git
alias gg=googler

# From https://kubernetes.io/docs/reference/kubectl/cheatsheet/
# alias k=kubectl
# [ -x "$(which kubectl)" ] && complete -F __start_kubectl k

alias -s {txt,py,conf,pl,yml,yaml}=vim
############################################################################}}}1

function _update_IT_books() {
  _BOOKS=$HOME/Documents/Livres && [[ -d $_BOOKS ]] || mkdir -p "$_BOOKS"  && \
    find "$_BOOKS" -maxdepth 1 -type l -exec rm "{}" \; && \
    calibredb list -s series:=Informatique  -f formats --for-machine | \
    jq '.[] | (.formats)' | \
    jq -r '.[]' | \
    while read elt; do ln -nfs "$elt" "$_BOOKS"; done
}


for plugin (
  $ZDOTDIR/opt/**/*.plugin.zsh(.)
  $ZDOTDIR/opt/spaceship-prompt/spaceship.zsh
  $HOME/.fzf.zsh
  $ZDOTDIR/opt/fzf/*.zsh(.)
  $HOME/.zsh/zshprivate
  ); [ -f $plugin ] && source $plugin

# Enable vi mode 
type spaceship_vi_mode_enable &>/dev/null && spaceship_vi_mode_enable

# https://starship.rs/
# eval "$(starship init zsh)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
