# menu-select widget, part of the zsh/complist module
# must be loaded before the call to compinit
zmodload -i zsh/complist

# Test on zsh completion list color, see complist documentation
export ZLS_COLORS="fi=33;so=10;di=35;"

# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# Add some completions functions to fpath
local _comp_path=~/.zsh/completion
[ -d $_comp_path ] && fpath+=$_comp_path

command -v brew &>/dev/null 2>&1 && \
    fpath+=$(brew --prefix)/share/zsh/site-functions

if [[ ! -e $ZDOTDIR/modules/zsh-completions ]]; then
  git clone --quiet --depth=1 https://github.com/zsh-users/zsh-completions.git $ZDOTDIR/modules/zsh-completions
  zcompile-many $ZDOTDIR/modules/zsh-completions/src/**/*.zsh
fi

fpath+=$ZDOTDIR/modules/zsh-completions/src

# Use modern completion system
autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

compinit -C

# if [ $(date +'%j') != $(date -r ${ZDOTDIR:-$HOME}/.zcompdump +'%j') ]; then
#   compinit
# else
#   compinit -C
# fi

# style {{{2
# Styles modify various operations of the completion system:
# - formatting,
# - what kinds of completers are used
# - which tags are examined
# See the `zstyle` command, in zshmodules doc
#
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Some functions, like _apt and _dpkg, are very slow. 
# Cache is used in order to proxy the list of results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"

# Case insensitive match
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
# zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# 2}}}

# SSH {{{2

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
# 2}}}


# Use command instead of which for checking commmand availability
# https://stackoverflow.com/a/677212

# command -v molecule &> /dev/null 2>&1 && eval "$(_MOLECULE_COMPLETE=source molecule)"
command -v direnv &>/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Generate completion if command exists
cmds=(arkade kubectl helm oc)
for cmd in ${cmds[@]}; do
    command -v $cmd &>/dev/null 2>&1 && \
        source <($cmd completion zsh)
done

# command -v arkade &>/dev/null 2>&1 && source <(arkade completion zsh)
# command -v kubectl &>/dev/null 2>&1 && source <(kubectl completion zsh)
# command -v oc &>/dev/null 2>&1 && source <(oc completion zsh)
# command -v helm &>/dev/null 2>&1 && source <(helm completion zsh)

command -v register-python-argcomplete &>/dev/null 2>&1 && {
    command -v airflow &>/dev/null 2>&1 && eval "$(register-python-argcomplete airflow)"
}

# command -v psql &>/dev/null 2&>1 && \
#     compdef _pgsql_psql pgcli

# alias -s {txt,py,conf,pl,yml,yaml}=vim

