# zmodload zsh/zprof

# TODO: set those in ansible
# TODO: oc completion broken
#
# For docker-compose, see documentation
# https://docs.docker.com/compose/completion/
#
# curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

# General {{{1
bindkey -v      # Use vi keybindings even if EDITOR is set to vi

# for jj and jk binding important
export KEYTIMEOUT=20
## bindkey jj and jk to cmd-mode
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode

HISTSIZE=1000   # Shell history and file
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

HELPDIR=/usr/share/zsh/help

# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space
setopt histignorealldups sharehistory

# Cursor {{{2
# Change cursor shape for different vi modes.
# https://unix.stackexchange.com/a/496878
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]] ||
    [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
# echo -ne 'Starting zsh'

    # Use beam shape cursor for each new prompt.
    _fix_cursor() {
        echo -ne '\e[5 q'
    }

precmd_functions+=(_fix_cursor)
# 2}}}

# }}}1

# Plugins {{{1
###############################################################################
# Load translate shell alias
source $ZDOTDIR/utils.zsh

for plugin (
    $ZDOTDIR/opt/**/*.plugin.zsh(.)
    $ZDOTDIR/opt/spaceship-prompt/spaceship.zsh
    $HOME/.fzf.zsh
    $ZDOTDIR/opt/fzf/*.zsh(.)
    $HOME/.zsh/zshprivate
    ); [ -f $plugin ] && source $plugin
    ###########################################################################}}}1

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

# Alias definitions {{{1
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# 1}}}

# Environment variables
# BSD specific
export CLICOLOR=1

# PATH {{{1
#======================================================================
#

if [ $(uname) = "Darwin" ]; then
    export HOMEBREW_NO_ANALYTICS=1
    export PATH="/opt/homebrew/bin/:$PATH"
    hash -r
fi
function _check_and_add_to_path() {

    path_to_be_checked=$(eval "realpath -q $1")


    if [ $? = 1 ]; then
        return
    fi

    case ":${PATH}:" in
        *:"$path_to_be_checked":*)
            ;;
        *)
            export PATH="$path_to_be_checked:$PATH"
            ;;
    esac
}

_check_and_add_to_path $HOME/.arkade/bin
_check_and_add_to_path $HOME/.local/bin
_check_and_add_to_path /opt/go/bin
_check_and_add_to_path $GOBIN
_check_and_add_to_path $RBENV_ROOT/shims
_check_and_add_to_path $RBENV_ROOT/bin
_check_and_add_to_path $PYENV_ROOT/shims
_check_and_add_to_path $PYENV_ROOT/bin
_check_and_add_to_path $HOME/.cargo/bin

# export PATH=$HOME/.arkade/bin:$HOME/.local/bin:$GOBIN:$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$HOME/.cargo/bin:/opt/go/bin:$PATH
# 1}}}
#======================================================================
# ghq {{{1
#======================================================================
command -v ghq &>/dev/null 2>&1 && {
    export GHQ_ROOT=$HOME/development
}
#======================================================================
# vivid {{{1
#======================================================================
command -v vivid &>/dev/null 2>&1 && {
    export LS_COLORS=$(vivid generate solarized-light)
}
# 1}}}
#======================================================================
# bat {{{1
#======================================================================
command -v bat &>/dev/null 2>&1 && {
    export BAT_PAGER='less'
    export BAT_STYLE='changes'
    export BAT_THEME='Monokai Extended Light'
    # bat can be used as a colorizing pager for man
    # See https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
}
# 1}}}
#======================================================================
# nnn {{{1
#======================================================================
export NNN_BMS="D:~/Documents;d:~/development;i:~/Images;v:~/Vidéos;m:~/Musique"
export NNN_OPTS="a"
export NNN_PLUG="d:downloader;p:preview-tui;z:autojump"
# 1}}}
#======================================================================
# alacritty {{{1
#======================================================================
export WINIT_X11_SCALE_FACTOR=1.666
# 1}}}
#======================================================================

# Completion {{{1
# menu-select widget, part of the zsh/complist module
# must be loaded before the call to compinit

zmodload -i zsh/complist
# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# Tell zsh which function to use for completing a command
fpath=(~/.zsh/completion $fpath)
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
# }}}2


# Use command instead of which for checking commmand availability
# https://stackoverflow.com/a/677212

# command -v molecule &> /dev/null 2>&1 && eval "$(_MOLECULE_COMPLETE=source molecule)"
command -v direnv &>/dev/null 2>&1 && eval "$(direnv hook zsh)"

# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
command -v arkade &>/dev/null 2>&1 && source <(arkade completion zsh)
command -v kubectl &>/dev/null 2>&1 && \
    source <(kubectl completion zsh)

command -v oc &>/dev/null 2>&1 && source <(oc completion zsh)
command -v helm &>/dev/null 2>&1 && source <(helm completion zsh)

command -v register-python-argcomplete &>/dev/null 2>&1 && {
    command -v airflow &>/dev/null 2>&1 && eval "$(register-python-argcomplete airflow)"
}

# From https://kubernetes.io/docs/reference/kubectl/cheatsheet/
# [ -x "$(which kubectl)" ] && complete -F __start_kubectl k

# alias -s {txt,py,conf,pl,yml,yaml}=vim

# eval "$(pyenv init zsh -)"
#
if command -v conda &> /dev/null
then
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
fi

# alternative to zshz for test
# TODO: test zoxide
# command -v jump &>/dev/null 2>&1 && eval "$(jump shell zsh)"
# }}}1

command -v helm &>/dev/null 2>&1 && eval "$(zoxide init zsh)" # vim:fdm=marker
