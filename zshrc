# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

setopt histignorealldups sharehistory

# Use vi keybindings even if our EDITOR is set to vi
bindkey -v

zmodload -i zsh/complist
# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# z command
[ -f /usr/local/share/zsh-z/zsh-z.plugin.zsh ] && \
  source /usr/local/share/zsh-z/zsh-z.plugin.zsh

# Tell zsh which function to use for completing a command
fpath=(~/.zsh/completion $fpath)
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh

[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

function _update_IT_books() {
  _BOOKS=$HOME/Documents/Livres && [[ -d $_BOOKS ]] || mkdir -p "$_BOOKS"  && \
    find "$_BOOKS" -maxdepth 1 -type l -exec rm "{}" \; && \
    calibredb list -s series:=Informatique  -f formats --for-machine | \
    jq '.[] | (.formats)' | \
    jq -r '.[]' | \
    while read elt; do ln -nfs "$elt" "$_BOOKS"; done
}

###############################################################################
# COMPLETION
###############################################################################
[ -x "$(which kubectl)" ] && source <(kubectl completion zsh)
[ -x "$(which oc)" ] && source <(oc completion zsh)
[ -x "$(which helm)" ] && source <(helm completion zsh)

# For docker-compose, see documentation
# https://docs.docker.com/compose/completion/
#
# curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose



###############################################################################
# ALIASES
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
# GIT
alias g=git

# Googler
alias gg=googler

# From https://kubernetes.io/docs/reference/kubectl/cheatsheet/
alias k=kubectl
complete -F __start_kubectl k

alias -s {txt,py,conf,pl,yml,yaml}=vim

[ -f ~/.zsh/zshprivate ] && source ~/.zsh/zshprivate  
eval "$(starship init zsh)"
