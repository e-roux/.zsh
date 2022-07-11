# zmodload zsh/zprof

# TODO: set those in ansible
# TODO: oc completion broken
#

# General {{{1
#----------------------------------------
# Use vi keybindings
bindkey -v

## bindkey jj and jk to cmd-mode
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode

# for jj and jk binding important
export KEYTIMEOUT=20

HISTSIZE=1000   # Shell history and file
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

HELPDIR=/usr/share/zsh/help

# Remove lines from the history list startiçng with space
setopt histignorespace
setopt histignorealldups sharehistory

# IGNOREEOF forces the user to type exit or logout, instead of just pressing ^D.
# in zsh, set with ignoreeof
setopt ignoreeof

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey ^e edit-command-line


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

# 1}}}

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
    # 1}}}

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
# 1}}}

# Alias definitions {{{1
if [ -f $ZDOTDIR/zsh_aliases ]; then
    . $ZDOTDIR/zsh_aliases
fi
# 1}}}

# Environment variables {{{1
# PATH {{{2

if [ $(uname) = "Darwin" ]; then
    # BSD specific
    export CLICOLOR=1
    export HOMEBREW_NO_ANALYTICS=1

    export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"

    # https://man7.org/linux/man-pages/man1/hash.1p.html
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

command -v brew &>/dev/null 2>&1 && \
    _check_and_add_to_path "$(brew --prefix)/opt/make/libexec/gnubin"
    _check_and_add_to_path $HOME/.local/bin
    _check_and_add_to_path /opt/go/bin
    _check_and_add_to_path $GOBIN
    _check_and_add_to_path $RBENV_ROOT/shims
    _check_and_add_to_path $RBENV_ROOT/bin
    _check_and_add_to_path $PYENV_ROOT/shims
    _check_and_add_to_path $PYENV_ROOT/bin
    _check_and_add_to_path $HOME/.cargo/bin

# 2}}}

# ghq {{{2
command -v ghq &>/dev/null 2>&1 && {
    export GHQ_ROOT=$HOME/development
}
# 2}}}

# vivid {{{2
command -v vivid &>/dev/null 2>&1 && {
    export LS_COLORS=$(vivid generate solarized-light)
}
# 2}}}

# bat {{{2
command -v bat &>/dev/null 2>&1 && {
    export BAT_PAGER='less'
    export BAT_STYLE='changes'
    export BAT_THEME='Solarized (light)'
    # bat can be used as a colorizing pager for man
    # See https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
}
# 2}}}

# nnn {{{2
export NNN_BMS="D:~/Documents;d:~/development;v:~/Movies;m:~/Music;p:~/Pictures;"
export NNN_OPTS="ade"  #
export NNN_FCOLORS="c1e2272e006033f7c6d6abc4"
export NNN_PLUG="d:downloader;p:preview-tui;z:autojump"
# 2}}}

# alacritty {{{2
command -v alacritty &>/dev/null 2>&1 && {
    export WINIT_X11_SCALE_FACTOR=1.666
}
# 2}}}

# 1}}}

# conda {{{1
#******************************************************************************
# Source conda configuration
# Base environment automatically activated with auto_activate_base
# https://docs.conda.io/projects/conda/en/latest/configuration.html
#******************************************************************************
function _register_conda {

    BREW_PREFIX=$(brew --prefix)
    __conda_setup="$('${BREW_PREFIX}/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${BREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "${BREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="${BREW_PREFIX}/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
}

command -v brew &>/dev/null 2>&1 && _register_conda
# 1}}}

# Completion {{{1
#

# menu-select widget, part of the zsh/complist module
# must be loaded before the call to compinit
zmodload -i zsh/complist

# Test on zsh completion list color, see complist documentation
export ZLS_COLORS="fi=33;so=10;di=35;"

# bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[Z' reverse-menu-complete

# Add some completions functions to fpath
fpath=(~/.zsh/completion $fpath)

command -v brew &>/dev/null 2>&1 && \
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

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

# From https://grml.org/zsh/zsh-lovers.html
# Some functions, like _apt and _dpkg, are very slow. Cache is used in order to
# proxy the list of results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case insensitive match
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

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

# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then

command -v arkade &>/dev/null 2>&1 && source <(arkade completion zsh)
command -v kubectl &>/dev/null 2>&1 && source <(kubectl completion zsh)
command -v oc &>/dev/null 2>&1 && source <(oc completion zsh)
command -v helm &>/dev/null 2>&1 && source <(helm completion zsh)

command -v register-python-argcomplete &>/dev/null 2>&1 && {
    command -v airflow &>/dev/null 2>&1 && eval "$(register-python-argcomplete airflow)"
}

# command -v psql &>/dev/null 2&>1 && \
#     compdef _pgsql_psql pgcli

# alias -s {txt,py,conf,pl,yml,yaml}=vim

# 1}}}

# Functions {{{1
function display_certs {
    # https://unix.stackexchange.com/a/97252
    awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < $1
}

function _display_certs {
    #compdef display_certs
    _alternative  'files:filename:_files'
}

compdef _display_certs display_certs

#  1}}}

# vim: set fdm=marker:
